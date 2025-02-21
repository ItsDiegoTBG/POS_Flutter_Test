import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_service.dart';

class DatabaseHelper implements DatabaseService {
  static Database? database;
  static final DatabaseHelper instance = DatabaseHelper._instance();

  DatabaseHelper._instance();

  Future<Database> get db async {
    database ??= await init();
    return database!;
  }

  @override
  Future<Database> init() async {
    final path = join(await getDatabasesPath(), 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // If needed, update schema with ALTER TABLE statements
          await db.execute('ALTER TABLE users ADD COLUMN name TEXT');
        }
      },
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUENOT NULL,
            password TEXT NOT NULL,
            userType TEXT NOT NULL DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            price REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE sales (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productId INTEGER,
            quantity INTEGER,
            totalPrice REAL,
            date TEXT,
            FOREIGN KEY (productId) REFERENCES products (id)
          )
        ''');
  }
  


  @override
  Future<int> insert(String table, Map<String, dynamic> data) async {
    return await database!.insert(table, data);
  }

  @override
  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    return await database!.query(table);
  }

  Future<List<Map<String, dynamic>>> query(String table, {required String where, required List<String> whereArgs}) async {
    return await database!.query(table);
  }
  @override
  Future<int> update(String table, Map<String, dynamic> data, String where, List<dynamic> whereArgs) async {
    return await database!.update(table, data, where: where, whereArgs: whereArgs);
  }

  @override
  Future<int> delete(String table, String where, List<dynamic> whereArgs) async {
    return await database!.delete(table, where: where, whereArgs: whereArgs);
  }

  @override
  Future<void> close() async {
    await database?.close();
  }
}