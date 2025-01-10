import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'tweets.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE tweets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            content TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
      version: 1,
    );
  }

  Future<int> insertTweet(Map<String, dynamic> tweet) async {
    final db = await database;
    return db.insert('tweets', tweet);
  }

  Future<List<Map<String, dynamic>>> getTweets() async {
    final db = await database;
    return db.query('tweets', orderBy: 'date DESC'); // Mendapatkan semua tweet
  }

  Future<List<Map<String, dynamic>>> getTweetsForUser(String username) async {
    final db = await database;
    return db.query(
      'tweets',
      where: 'username = ?',
      whereArgs: [username],
      orderBy: 'date DESC',
    );
  }

  Future<int> deleteTweet(int id, String username) async {
    final db = await database;
    return db.delete(
      'tweets',
      where: 'id = ? AND username = ?',
      whereArgs: [id, username],
    );
  }
}
