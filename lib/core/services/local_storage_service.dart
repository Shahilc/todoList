import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/todo_model.dart';

class DatabaseHelper {
  static const _databaseName = 'todo.db';
  static const _databaseVersion = 1;

  static const _tableName = 'todos';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firebaseId TEXT,
            name TEXT,
            description TEXT,
            startDate TEXT,
            endDate TEXT,
            priority TEXT,
            is_synced INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertTodo(Todo todo) async {
    final db = await database;
    return await db.insert(_tableName, todo.toMap());
  }

  Future<List<Todo>> getTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return maps.map((map) => Todo.fromMap(map)).toList();
  }

  Future<int> updateTodo(Todo todo) async {
    final db = await database;
    return await db.update(
      _tableName,
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(int id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Todo>> getUnsyncedTodos() async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'is_synced = ?',
      whereArgs: [0],
    );
    return maps.map((map) => Todo.fromMap(map)).toList();
  }
}
