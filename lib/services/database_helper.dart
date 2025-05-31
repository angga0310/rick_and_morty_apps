import 'package:path/path.dart';
import 'package:rick_and_morty_apps/models/fav_character.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _db;

  // Singleton pattern: returns existing DB or opens new one
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  // Initialize database & create favorites table if not exists
  Future<Database> _initDb() async {
    final dbPath = join(await getDatabasesPath(), 'favorite_characterss.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY,
            name TEXT,
            status TEXT,
            species TEXT,
            type TEXT,
            gender TEXT,
            originName TEXT,
            locationName TEXT,
            image TEXT,
            episodeCount INTEGER,
            url TEXT,
            created TEXT
          )
        ''');
        print('Database created with favorites table!');
      },
    );
  }

  // Insert favorite character
  Future<void> insertFavorite(FavoriteCharacter character) async {
    final db = await database;
    await db.insert(
      'favorites',
      character.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Favorite inserted: ${character.name}');
  }

  // Delete favorite character by id
  Future<void> deleteFavorite(int id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
    print('Favorite with id=$id deleted.');
  }

  // Get all favorite characters
  Future<List<FavoriteCharacter>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(
      maps.length,
      (i) => FavoriteCharacter.fromMap(maps[i]),
    );
  }
}
