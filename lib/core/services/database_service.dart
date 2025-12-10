import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';
import '../helpers/logging_service.dart';

class DatabaseService {
  DatabaseService._();

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    LoggingServicePrinter.log('🗄️ Initializing database...');
    
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    LoggingServicePrinter.log('📝 Creating database tables...');

    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        hashed_password TEXT NOT NULL,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // News articles table
    await db.execute('''
      CREATE TABLE news_articles (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        url TEXT NOT NULL,
        url_to_image TEXT,
        source_name TEXT,
        author TEXT,
        published_at TEXT NOT NULL,
        category TEXT,
        cached_at TEXT NOT NULL
      )
    ''');

    // Weather data table
    await db.execute('''
      CREATE TABLE weather_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        city_id INTEGER NOT NULL,
        temperature REAL NOT NULL,
        feels_like REAL,
        temp_min REAL,
        temp_max REAL,
        pressure INTEGER,
        humidity INTEGER,
        weather_main TEXT NOT NULL,
        weather_description TEXT NOT NULL,
        weather_icon TEXT NOT NULL,
        wind_speed REAL,
        wind_deg INTEGER,
        clouds INTEGER,
        cached_at TEXT NOT NULL
      )
    ''');

    // Cities table
    await db.execute('''
      CREATE TABLE cities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        country TEXT NOT NULL,
        lat REAL NOT NULL,
        lon REAL NOT NULL,
        is_default INTEGER DEFAULT 0
      )
    ''');

    // Forecast data table
    await db.execute('''
      CREATE TABLE forecast_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        city_id INTEGER NOT NULL,
        dt INTEGER NOT NULL,
        temperature REAL NOT NULL,
        feels_like REAL,
        temp_min REAL,
        temp_max REAL,
        pressure INTEGER,
        humidity INTEGER,
        weather_main TEXT NOT NULL,
        weather_description TEXT NOT NULL,
        weather_icon TEXT NOT NULL,
        wind_speed REAL,
        clouds INTEGER,
        pop REAL,
        cached_at TEXT NOT NULL,
        FOREIGN KEY (city_id) REFERENCES cities (id) ON DELETE CASCADE
      )
    ''');

    LoggingServicePrinter.log('✅ Database tables created successfully');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    LoggingServicePrinter.log('⬆️ Upgrading database from v$oldVersion to v$newVersion');
    // Add migration logic here when needed
  }

  static Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      LoggingServicePrinter.log('🔒 Database closed');
    }
  }

  static Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.dbName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
    LoggingServicePrinter.log('🗑️ Database deleted');
  }
}
