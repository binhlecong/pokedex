import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokedex/database/db_models.dart';
import 'package:sqflite/sqflite.dart';

class FavoritePokemonDB {
  static const tablename = "FavoritePokemon";

  FavoritePokemonDB._();

  static final FavoritePokemonDB db = FavoritePokemonDB._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "pokemon.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE $tablename (
          id INTEGER PRIMARY KEY,
          name TEXT
          )''');
      },
    );
  }

  newPokemon(FavoritePokemon newPokemon) async {
    final db = await database;

    newPokemon.id = await db
        .insert(
          tablename,
          {
            'id': newPokemon.id,
            'name': newPokemon.name,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        )
        .then((value) => newPokemon.id = value);

    return newPokemon.id;
  }

  updateFavoritePokemon(FavoritePokemon newFavoritePokemon) async {
    final db = await database;
    var res = await db.update(tablename, newFavoritePokemon.toMap(),
        where: "id = ?", whereArgs: [newFavoritePokemon.id]);
    return res;
  }

  getFavoritePokemon(int id) async {
    final db = await database;
    var res = await db.query(tablename, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? FavoritePokemon.fromMap(res.first) : null;
  }

  Future<List<FavoritePokemon>> getAllFavoritePokemons() async {
    final db = await database;
    var res = await db.query(tablename);
    List<FavoritePokemon> list = res.isNotEmpty
        ? res.map((c) => FavoritePokemon.fromMap(c)).toList()
        : [];
    return list;
  }

  deleteFavoritePokemon(int id) async {
    final db = await database;
    return db.delete(tablename, where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from $tablename");
  }
}
