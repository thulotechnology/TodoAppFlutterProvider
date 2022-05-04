import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app_provider/models/todomodel.dart';

class DatabaseHelper {
  // Singleton
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;
  String dbName = "todos.db";
  String tableName = "my";

  DatabaseHelper._init();

  Future<Database> get database async {
    _database = await _initDB(dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    String sql = """
    CREATE TABLE "$tableName" (
	"id"	INTEGER,
	"title"	TEXT NOT NULL,
	"description"	TEXT,
	"isImportant"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);
    """;
    await db.execute(sql);
  }

  Future<Todo> addTodo(Todo t) async {
    final db = await instance.database;
    final id = await db.insert(tableName, t.toMap());
    return t.copy(id: id);
  }

  Future<List<Todo>> listAllTodo() async {
    final db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) {
      return Todo(
          id: maps[index]['id'],
          title: maps[index]['title'],
          description: maps[index]['description'],
          isImportant: maps[index]['isImportant']);
    }).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  // Delete
  Future<bool> deleteTodo(int id) async {
    try {
      final db = await instance.database;
      await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> deleteAll() async {
    try {
      final db = await instance.database;
      await db.delete(
        tableName,
      );
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> updateTodo(Todo p) async {
    // Get a reference to the database.
    try {
      final db = await database;
      await db.update(
        tableName,
        p.toMap(),
        where: 'id = ?',
        whereArgs: [p.id],
      );
      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }
}
