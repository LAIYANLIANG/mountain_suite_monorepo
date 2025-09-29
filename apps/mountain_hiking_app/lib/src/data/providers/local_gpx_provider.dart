import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mountain_hiking_app/src/data/models/gpx_track.dart';
import 'package:mountain_hiking_app/src/data/providers/gpx_data_provider.dart';

class LocalGpxProvider implements GpxDataProvider {
  static Database? _database;
  static const String _tableName = 'gpx_tracks';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'gpx_database.db');
    return await openDatabase(
      path,
      version: 2, // FIX: Incremented database version to trigger onUpgrade.
      onCreate: (db, version) async {
        // FIX: This schema now matches the GpxTrack model exactly.
        await db.execute('''
          CREATE TABLE $_tableName(
            id TEXT PRIMARY KEY, 
            name TEXT, 
            storagePath TEXT, 
            downloadUrl TEXT, 
            date TEXT, 
            distanceKm REAL, 
            elevationGainMeters REAL
          )
        ''');
      },
      // FIX: Added onUpgrade callback to handle schema migration for existing users.
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // This ensures users from v1 get the new columns without losing data.
          await db.execute('ALTER TABLE $_tableName ADD COLUMN downloadUrl TEXT;');
          await db.execute('ALTER TABLE $_tableName ADD COLUMN distanceKm REAL;');
          await db.execute('ALTER TABLE $_tableName ADD COLUMN elevationGainMeters REAL;');
        }
      },
    );
  }

  @override
  Future<List<GpxTrack>> getTracks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return GpxTrack.fromMap(maps[i]);
    });
  }

  @override
  Future<GpxTrack> addTrack(Uint8List gpxBytes, String customName, String originalFileName) async {
    final db = await database;
    final appDocPath = (await getApplicationDocumentsDirectory()).path;
    final trackId = DateTime.now().millisecondsSinceEpoch.toString(); // Simple unique ID
    final localPath = '$appDocPath/$trackId.gpx';

    // Save GPX content to file
    final file = File(localPath);
    await file.writeAsBytes(gpxBytes);
    print('[LocalGpxProvider] Saved GPX file to: $localPath'); // LOG

    // Parse GPX metadata (simplified for now)
    final gpxTrack = GpxTrack(
      id: trackId,
      name: customName.isNotEmpty ? customName : originalFileName.replaceAll('.gpx', ''),
      storagePath: localPath,
      date: DateTime.now(),
      distanceKm: 0.0, // Placeholder, actual parsing happens in BLoC
      elevationGainMeters: 0.0, // Placeholder
    );

    await db.insert(
      _tableName,
      gpxTrack.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('[LocalGpxProvider] Added track metadata to DB: ${gpxTrack.id}'); // LOG
    return gpxTrack;
  }

  @override
  Future<void> deleteTrack(String trackId) async {
    final db = await database;
    final localPath = await getTrackLocalPath(trackId); // Get path to delete file
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [trackId],
    );
    print('[LocalGpxProvider] Deleted track metadata from DB: $trackId'); // LOG
    // Delete the actual file
    final file = File(localPath);
    if (await file.exists()) {
      await file.delete();
      print('[LocalGpxProvider] Deleted GPX file: $localPath'); // LOG
    }
  }

  @override
  Future<String> getTrackLocalPath(String trackId) async {
    final db = await database;
    print('[LocalGpxProvider] Querying DB for trackId: $trackId'); // LOG
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [trackId],
    );
    if (maps.isNotEmpty) {
      print('[LocalGpxProvider] Found track in DB: ${maps.first['local_path']}'); // LOG
      return maps.first['local_path'];
    } else {
      print('[LocalGpxProvider] Track NOT found in DB for trackId: $trackId'); // LOG
      throw Exception('Track not found in local database');
    }
  }
}
