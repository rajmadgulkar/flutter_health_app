import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB("fitness_app.db");
    return _db!;
  }

  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE assessments(
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            isFavourite INTEGER,
            imagePath TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE appointments(
            id TEXT PRIMARY KEY,
            title TEXT,
            svgPath TEXT,
            bgColor INTEGER
          )
        ''');
      },
    );
  }
}
