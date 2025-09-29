import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mountain_hiking_app/src/data/models/gpx_track.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

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
CREATE TABLE gpx_tracks (
  id $idType,
  name $textType,
  storagePath $textType,
  distanceKm $doubleType,
  elevationGainMeters $doubleType,
  date $textType,
  downloadUrl TEXT
)
''');
  }

  Future<void> createTrack(GpxTrack track) async {
    final db = await instance.database;
    await db.insert('gpx_tracks', track.toMap());
  }

  Future<GpxTrack?> getTrackById(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'gpx_tracks',
      columns: ['id', 'name', 'storagePath', 'distanceKm', 'elevationGainMeters', 'date', 'downloadUrl'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return GpxTrack.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<GpxTrack>> getAllTracks() async {
    final db = await instance.database;
    final result = await db.query('gpx_tracks', orderBy: 'date DESC');
    return result.map((json) => GpxTrack.fromMap(json)).toList();
  }

  Future<int> deleteTrack(String id) async {
    final db = await instance.database;
    return await db.delete(
      'gpx_tracks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
