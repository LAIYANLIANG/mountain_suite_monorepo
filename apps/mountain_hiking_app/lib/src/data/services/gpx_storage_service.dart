import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mountain_hiking_app/src/data/models/gpx_track.dart';
import 'package:xml/xml.dart';
import 'dart:math' as math; // For Haversine formula
import 'dart:convert'; // For utf8.decode

class GpxStorageService {
  static final GpxStorageService instance = GpxStorageService._init();
  static Database? _database;
  final String _tableName = 'gpx_tracks';

  GpxStorageService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gpx_tracks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE $_tableName ( 
  id $idType, 
  name $textType,
  storagePath $textType,
  distanceKm $doubleType,
  elevationGainMeters $doubleType,
  date $textType,
  thumbnailUrl $textType
  )
''');
  }

  Future<GpxTrack> addTrack(PlatformFile file) async {
    if (file.bytes == null) {
      throw Exception("File bytes are null");
    }

    // 1. Save the physical file
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String newFileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    final String newFilePath = join(appDir.path, newFileName);
    final File newFile = File(newFilePath);
    await newFile.writeAsBytes(file.bytes!);

    // 2. Parse the file for metadata
    final metadata = _parseGpxData(file.bytes!, file.name);

    // 3. Create GpxTrack object - 使用 storagePath 而不是 filePath
    final newTrack = GpxTrack(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: metadata['name'] as String,
      storagePath: newFilePath,
      distanceKm: metadata['distanceKm'] as double,
      elevationGainMeters: metadata['elevationGainMeters'] as double,
      date: metadata['date'] as DateTime,
    );

    // 4. Insert into database
    final db = await instance.database;
    await db.insert(_tableName, newTrack.toMap());
    
    return newTrack;
  }

  Future<List<GpxTrack>> getTracks() async {
    final db = await instance.database;
    final maps = await db.query(_tableName, orderBy: 'date DESC');

    if (maps.isNotEmpty) {
      return maps.map((map) => GpxTrack.fromMap(map)).toList();
    } else {
      return [];
    }
  }

  Future<void> deleteTrack(String id) async {
    final db = await instance.database;
    
    // 1. Find the track to get the file path
    final maps = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      final track = GpxTrack.fromMap(maps.first);
      
   // 2. Delete the physical file - 使用 storagePath
      final file = File(track.storagePath);
      if (await file.exists()) {
        await file.delete();
      }
      
      // 3. Delete the record from the database
      await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    }
  }

  Map<String, dynamic> _parseGpxData(Uint8List gpxBytes, String fallbackName) {
    final String content = utf8.decode(gpxBytes);
    final XmlDocument document = XmlDocument.parse(content);
    final XmlElement root = document.rootElement;

    String name = root.findElements('metadata').firstOrNull?.findElements('name').firstOrNull?.innerText ?? fallbackName;
    DateTime date = DateTime.now();
    try {
      final timeStr = root.findElements('metadata').firstOrNull?.findElements('time').firstOrNull?.innerText;
      if (timeStr != null) {
        date = DateTime.parse(timeStr);
      }
    } catch (e) {
      print('Error parsing date: $e');
    }

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
      final ele = double.tryParse(pt.findElements('ele').firstOrNull?.innerText ?? '');

      if (lat != null && lon != null) {
        if (prevLat != null && prevLon != null) {
          totalDistance += _calculateDistance(prevLat, prevLon, lat, lon);
        }
        prevLat = lat;
        prevLon = lon;
      }

      if (ele != null && prevEle != null) {
        if (ele > prevEle) {
          totalElevationGain += (ele - prevEle);
        }
      }
      prevEle = ele;
    }

    return {
      'name': name,
      'distanceKm': totalDistance / 1000,
      'elevationGainMeters': totalElevationGain,
      'date': date,
    };
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
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

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
