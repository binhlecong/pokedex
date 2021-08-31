import 'package:flutter/material.dart';
import 'package:pokedex/database/db_models.dart';
import 'package:pokedex/database/favorite_pokemon_db.dart';

class FavoriteChecker with ChangeNotifier {
  late bool _isFavorite;
  get isFavorite => _isFavorite;

  FavoriteChecker() {
    _isFavorite = false;
    notifyListeners();
  }

  checkFavorite(int id) async {
    var res = await FavoritePokemonDB.db.getFavoritePokemon(id);

    if (res == null) {
      _isFavorite = false;
    } else {
      _isFavorite = true;
    }

    notifyListeners();
  }

  addToFavorite(int id, String name) async {
    await FavoritePokemonDB.db.newPokemon(FavoritePokemon(id: id, name: name));
    _isFavorite = true;
    notifyListeners();
  }

  deleteFromFavorite(int id) async {
    await FavoritePokemonDB.db.deleteFavoritePokemon(id);
    _isFavorite = false;
    notifyListeners();
  }
}
