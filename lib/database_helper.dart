import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String databasePath = await getDatabasesPath();
    final String path = join(databasePath, 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT,
        role INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE properties(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        property_type TEXT,
        building_area REAL,
        surface_area REAL,
        price REAL,
        room INTEGER,
        bathroom INTEGER,
        floor INTEGER,
        image TEXT
      )
    ''');
  }

  // User CRUD Operations

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    return await db.insert('users', user);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await instance.database;
    return await db.query('users');
  }

  // Property CRUD Operations

  Future<int> insertProperty(Map<String, dynamic> property) async {
    final db = await instance.database;
    return await db.insert('properties', property);
  }

  Future<List<Map<String, dynamic>>> getProperties() async {
    final db = await instance.database;
    return await db.query('properties');
  }

  Future<int> updateProperty(Map<String, dynamic> property) async {
    final db = await instance.database;
    final int id = property['id'];
    return await db.update(
      'properties',
      property,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteProperty(int id) async {
    final db = await instance.database;
    return await db.delete(
      'properties',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
