// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:finance_app/models/group.dart';
import 'package:finance_app/models/expense.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:finance_app/models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('finance_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Aumentando a versão para 2
      onCreate: _createDB,
      onUpgrade: _onUpgrade, // Adicionando o onUpgrade
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users ( 
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        username TEXT NOT NULL,
        password TEXT NOT NULL
        )
      ''');

    await db.execute('''
      CREATE TABLE expense ( 
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        title TEXT NOT NULL,
        value REAL NOT NULL,
        groupId INTEGER
        )
      ''');

    await db.execute('''
      CREATE TABLE groups ( 
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT NOT NULL
        )
      ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE groups ( 
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          name TEXT NOT NULL
          )
        ''');
    }
    // Implemente futuras atualizações da versão aqui
  }

  Future<User?> fetchUser(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<List<User>> fetchAllUsers() async {
    final db = await instance.database;
    final result = await db.query('users');

    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<int> addUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<int> addExpense(Expense expense) async {
    final db = await instance.database;
    return await db.insert('expense', expense.toMap());
  }

  Future<int> addGroup(Group group) async {
    final db = await instance.database;
    return await db.insert('groups', group.toMap());
  }

  Future<List<Group>> loadGroups() async {
    final db = await instance.database;
    final result = await db.query('groups');

    return result.map((map) => Group.fromMap(map)).toList();
  }
}
