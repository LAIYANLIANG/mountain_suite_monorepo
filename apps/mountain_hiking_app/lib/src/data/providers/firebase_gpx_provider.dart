import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mountain_hiking_app/src/data/models/gpx_track.dart';
import 'package:mountain_hiking_app/src/data/providers/gpx_data_provider.dart';
import 'package:xml/xml.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart' as firebase;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// [MVP Refactor] GPX Firebase 雲端數據提供者
///
/// 這是 GpxDataProvider 的 Firebase 實作版本。
/// 它包含了所有原先與 Firebase (Firestore, Storage) 互動的邏輯。
/// 在離線模式下，這個類別不會被使用，但程式碼被完整保留，
/// 以便未來可以透過功能開關快速切換回雲端模式。
class FirebaseGpxProvider implements GpxDataProvider {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  FirebaseGpxProvider({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get _userId {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _tracksCollection =>
      _firestore.collection('users').doc(_userId).collection('tracks');

  @override
  Future<List<GpxTrack>> getTracks() async {
    final snapshot = await _tracksCollection.orderBy('date', descending: true).get();
    return snapshot.docs.map((doc) => GpxTrack.fromFirestore(doc)).toList();
  }

  @override
  Future<GpxTrack> addTrack(Uint8List gpxBytes, String customName, String originalFileName) async {
    final newDocRef = _tracksCollection.doc();
    final String trackId = newDocRef.id;
    // [MODIFIED] 使用原始檔名來建立 Storage 中的路徑
    final String storagePath = 'gpx_files/$_userId/$trackId/$originalFileName';

    final ref = _storage.ref(storagePath);
    await ref.putData(gpxBytes);
    final String downloadUrl = await ref.getDownloadURL();

    // [MODIFIED] 解析 GPX 以獲取距離、海拔等數據，但名稱將使用自訂名稱
    final metadata = _parseGpxMetadata(gpxBytes, customName);

    final newTrack = GpxTrack(
      id: trackId,
      name: customName, // [MODIFIED] 直接使用傳入的自訂名稱
      storagePath: storagePath,
      downloadUrl: downloadUrl,
      date: metadata['date'] as DateTime,
      distanceKm: metadata['distanceKm'] as double,
      elevationGainMeters: metadata['elevationGainMeters'] as double,
    );

    await newDocRef.set(newTrack.toFirestore());
    return newTrack;
  }

  @override
  Future<void> deleteTrack(String trackId) async {
    final docRef = _tracksCollection.doc(trackId);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) throw Exception("Track not found");

    final track = GpxTrack.fromFirestore(docSnapshot);

    try {
      await _storage.ref(track.storagePath).delete();
    } on firebase.FirebaseException catch (e) {
      if (e.code != 'object-not-found') rethrow;
    }

    await docRef.delete();
  }

  @override
  Future<String> getTrackLocalPath(String trackId) async {
    final docRef = _tracksCollection.doc(trackId);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) throw Exception("Track not found in Firestore.");

    final track = GpxTrack.fromFirestore(docSnapshot);
    final tempDir = await getTemporaryDirectory();
    final localFilePath = '${tempDir.path}/${track.id}_${track.name}.gpx';
    final file = File(localFilePath);

    await _storage.ref(track.storagePath).writeToFile(file);
    return localFilePath;
  }

  Map<String, dynamic> _parseGpxMetadata(Uint8List gpxBytes, String fallbackName) {
     try {
      final String content = utf8.decode(gpxBytes, allowMalformed: true);
      final XmlDocument document = XmlDocument.parse(content);
      final XmlElement? root = document.rootElement;

      if (root == null) throw Exception("Invalid GPX file");

      String name = root.findElements('metadata').firstOrNull?.findElements('name').firstOrNull?.innerText ??
                    root.findElements('trk').firstOrNull?.findElements('name').firstOrNull?.innerText ??
                    fallbackName.replaceAll(RegExp(r'\\.gpx$', caseSensitive: false), '');
      
      DateTime date = DateTime.now();
      try {
        final timeStr = root.findElements('metadata').firstOrNull?.findElements('time').firstOrNull?.innerText;
        if (timeStr != null) {
          date = DateTime.parse(timeStr);
        }
      } catch (_) { /* Ignore date parsing errors, use now() */ }

      double totalDistance = 0.0;
      double totalElevationGain = 0.0;
      double? prevLat, prevLon, prevEle;

      final points = root.findAllElements('trkpt').toList();
      if (points.isEmpty) {
        points.addAll(root.findAllElements('rtept'));
      }

      for (final pt in points) {
        final lat = double.tryParse(pt.getAttribute('lat') ?? '');
        final lon = double.tryParse(pt.getAttribute('lon') ?? '');
        final eleStr = pt.findElements('ele').firstOrNull?.innerText;
        final ele = eleStr != null ? double.tryParse(eleStr) : null;

        if (lat != null && lon != null) {
          if (prevLat != null && prevLon != null) {
            totalDistance += _calculateHaversineDistance(prevLat, prevLon, lat, lon);
          }
          prevLat = lat;
          prevLon = lon;
        }

        if (ele != null) {
          if (prevEle != null && ele > prevEle) {
            totalElevationGain += (ele - prevEle);
          }
          prevEle = ele;
        }
      }

      return {
        'name': name,
        'distanceKm': totalDistance / 1000,
        'elevationGainMeters': totalElevationGain,
        'date': date,
      };
    } catch (e) {
      return {
        'name': fallbackName.replaceAll(RegExp(r'\\.gpx$', caseSensitive: false), ''),
        'distanceKm': 0.0,
        'elevationGainMeters': 0.0,
        'date': DateTime.now(),
      };
    }
  }

  double _calculateHaversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371e3; // metres
    final phi1 = lat1 * (math.pi / 180);
    final phi2 = lat2 * (math.pi / 180);
    final deltaPhi = (lat2 - lat1) * (math.pi / 180);
    final deltaLambda = (lon2 - lon1) * (math.pi / 180);

    final a = math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
        math.cos(phi1) * math.cos(phi2) *
            math.sin(deltaLambda / 2) * math.sin(deltaLambda / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return R * c; // in metres
  }
}
