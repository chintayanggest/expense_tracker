import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/savings_goal.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'expense_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabel untuk savings goals
    await db.execute('''
      CREATE TABLE savings_goals(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        targetAmount REAL NOT NULL,
        currentAmount REAL NOT NULL DEFAULT 0,
        targetDate TEXT
      )
    ''');

    // Tabel untuk expenses (jika belum ada)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS expenses(
        id TEXT PRIMARY KEY,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        description TEXT,
        date TEXT NOT NULL,
        goalId TEXT,
        FOREIGN KEY (goalId) REFERENCES savings_goals (id)
      )
    ''');
  }

  // CRUD Operations untuk Savings Goals

  // Create - Tambah goal baru
  Future<int> insertGoal(SavingsGoal goal) async {
    final db = await database;
    return db.insert(
      'savings_goals',
      goal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read - Ambil semua goals
  Future<List<SavingsGoal>> getAllGoals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'savings_goals',
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) {
      return SavingsGoal.fromMap(maps[i]);
    });
  }

  // Read - Ambil goal berdasarkan ID
  Future<SavingsGoal?> getGoalById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'savings_goals',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return SavingsGoal.fromMap(maps.first);
  }

  // Update - Update goal
  Future<int> updateGoal(SavingsGoal goal) async {
    final db = await database;
    return db.update(
      'savings_goals',
      goal.toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

  // Update - Tambah dana ke goal
  Future<int> addFundsToGoal(String goalId, double amount) async {
    final goal = await getGoalById(goalId);

    if (goal == null) return 0;

    final updatedGoal = goal.copyWith(
      currentAmount: goal.currentAmount + amount,
    );

    return updateGoal(updatedGoal);
  }

  // Delete - Hapus goal
  Future<int> deleteGoal(String id) async {
    final db = await database;
    return db.delete(
      'savings_goals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Insert expense terkait goal (untuk "Add Funds")
  Future<int> insertSavingsExpense(String goalId, double amount, DateTime date) async {
    final db = await database;
    return db.insert(
      'expenses',
      {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'amount': amount,
        'category': 'Savings',
        'description': 'Added to savings goal',
        'date': date.toIso8601String(),
        'goalId': goalId,
      },
    );
  }

  // Helper untuk close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}