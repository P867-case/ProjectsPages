import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'ModelQrCode.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'qr_codes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE qr_codes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        imagePath TEXT
      )
    ''');
  }

  // Добавление QR-кода в базу данных
  Future<void> insertQrCode(QrCode qrCode) async {
    final db = await database;
    await db.insert('qr_codes', qrCode.toMap());
  }

  // Получение всех QR-кодов из базы данных
  Future<List<QrCode>> getQrCodes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('qr_codes');
    return List.generate(maps.length, (i) {
      return QrCode.fromMap(maps[i]);
    });
  }

  // Удаление QR-кода по ID
  Future<void> deleteQrCode(int id) async {
    final db = await database;
    await db.delete('qr_codes', where: 'id = ?', whereArgs: [id]);
  }
}