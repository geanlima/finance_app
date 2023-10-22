// ignore_for_file: depend_on_referenced_packages

import 'package:finance_app/models/group.dart';
import 'package:finance_app/models/expense.dart';
import 'package:intl/intl.dart';
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
    // Verificar se a tabela 'users' já existe e criá-la se não existir
    await _createTableIfNotExists(db, 'users', '''
      CREATE TABLE users ( 
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Verificar se a tabela 'expense' já existe e criá-la se não existir
    await _createTableIfNotExists(db, 'expense', '''
    CREATE TABLE expense ( 
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      title TEXT NOT NULL,
      value REAL NOT NULL,
      groupId INTEGER,
      date TEXT NOT NULL, -- Adicione o campo de data
      type TEXT NOT NULL  -- Adicione o campo de tipo
    )
  ''');

    // Verificar se a tabela 'groups' já existe e criá-la se não existir
    await _createTableIfNotExists(db, 'groups', '''
      CREATE TABLE groups ( 
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createTableIfNotExists(
      Database db, String tableName, String creationQuery) async {
    var tableExists = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'");
    if (tableExists.isEmpty) {
      await db.execute(creationQuery);
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

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

  Future<List<Expense>> loadExpenses() async {
    final db = await instance.database;
    final result =
        await db.query('expense'); // Suponho que a tabela se chama 'expense'

    return result.map((map) => Expense.fromMap(map)).toList();
  }

  Future<List<Expense>> loadExpensesForDate(String formattedDate) async {
    final db = await instance.database;
    final result = await db.query(
      'expense',
      where: 'date = ?',
      whereArgs: [formattedDate],
    );

    return result.map((map) => Expense.fromMap(map)).toList();
  }

  Future<List<Expense>> loadExpensesForDateAndType(
      DateTime date, String type) async {
    final db = await instance.database;
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    String query = 'SELECT * FROM expense WHERE date = ?';

    if (type != 'Todos') {
      query += ' AND type = ?';
    }

    List<Map<String, dynamic>> maps;
    if (type != 'Todos') {
      maps = await db.rawQuery(query, [formattedDate, type]);
    } else {
      maps = await db.rawQuery(query, [formattedDate]);
    }

    return List.generate(maps.length, (i) {
      return Expense(
        id: maps[i]['id'],
        title: maps[i]['title'],
        value: maps[i]['value'],
        groupId: maps[i]['groupId'],
        date: DateTime.parse(maps[i]['date']),
        type: maps[i]['type'],
      );
    });
  }

  Future<int> deleteExpense(int expenseId) async {
    final db = await instance.database;
    return await db.delete(
      'expense',
      where: 'id = ?',
      whereArgs: [expenseId],
    );
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

  Future<int> deleteGroup(int id) async {
    var db = await database;
    return await db.delete(
      'groups', // Correção aqui: era 'group', deve ser 'groups'
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateGroup(Group group) async {
    final db = await instance.database;
    return await db.update(
      'groups',
      group.toMap(),
      where: 'id = ?',
      whereArgs: [group.id],
    );
  }

  Future<void> dropAndRecreateDatabase() async {
    final db = await instance.database;
    await db.close(); // Feche a conexão atual

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'finance_app.db');
    await deleteDatabase(path); // Exclua o banco de dados

    // Reabra o banco de dados chamando a função _initDB
    _database = await _initDB('finance_app.db');
  }

  Future<void> closeDatabase() async {
    final db = await database;
    //db.close();
  }
}
