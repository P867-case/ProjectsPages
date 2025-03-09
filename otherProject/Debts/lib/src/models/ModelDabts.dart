import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'debts.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE debts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        amount INTEGER,
        priority TEXT
      )
    ''');
  }

  // Добавление долга
  Future<void> insertDebt(Map<String, dynamic> debt) async {
    final db = await database;
    await db.insert('debts', debt, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Получение всех долгов
  Future<List<Map<String, dynamic>>> getDebts() async {
    final db = await database;
    return await db.query('debts');
  }

  // Удаление долга
  Future<void> deleteDebt(int id) async {
    final db = await database;
    await db.delete('debts', where: 'id = ?', whereArgs: [id]);
  }
}