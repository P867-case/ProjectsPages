import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'ModelBankView.dart';

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
    final path = join(dbPath, 'banks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE banks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT
      )
    ''');
  }

  // Добавление банка в базу данных
  Future<void> insertBank(Bank bank) async {
    final db = await database;
    await db.insert('banks', bank.toMap());
  }

  // Получение всех банков из базы данных
  Future<List<Bank>> getBanks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('banks');
    return List.generate(maps.length, (i) {
      return Bank.fromMap(maps[i]);
    });
  }

  // Удаление банка по ID
  Future<void> deleteBank(int id) async {
    final db = await database;
    await db.delete('banks', where: 'id = ?', whereArgs: [id]);
  }
}