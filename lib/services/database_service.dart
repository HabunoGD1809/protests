import 'dart:ffi';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as p;

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  void _loadSqliteLibrary() {
    final libraryPath = p.join(Directory.current.path, 'lib', 'sqlite', 'sqlite3.dll');
    open.overrideFor(OperatingSystem.windows, () {
      return DynamicLibrary.open(libraryPath);
    });
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _loadSqliteLibrary();
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, 'protestas.db');

    final db = sqlite3.open(path);

    db.execute('DROP TABLE IF EXISTS users');

    db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        lastName TEXT NOT NULL,
        photo TEXT NOT NULL,
        role TEXT NOT NULL,
        cedula TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    db.execute('DROP TABLE IF EXISTS protests');

    db.execute('''
      CREATE TABLE protests (
        uuid TEXT PRIMARY KEY,
        userId INTEGER NOT NULL,
        natureName TEXT NOT NULL,
        natureIcon INTEGER NOT NULL,
        natureColor INTEGER NOT NULL,
        province TEXT NOT NULL,
        summary TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    return db;
  }
}
