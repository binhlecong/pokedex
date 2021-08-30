
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_batch.dart';
import 'package:pokedex/models/pokemon_categories.dart';
import 'package:pokedex/models/pokemon_type.dart';




class PokeAPI {
  static Future<Pokemon> fetchPokemonByID(int id) async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id/'));

    if (response.statusCode == 200) {
      return Pokemon.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load pokemon $id');
    }
  }

  static Future<Pokemon> fetchPokemonByURL(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Pokemon.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load pokemon from $url');
    }
  }

  static Future<PokemonBatch> fetchListPokemon(
      {String url = 'https://pokeapi.co/api/v2/pokemon/'}) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return PokemonBatch.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load list of pokemon from $url');
    }
  }

  static Future<PokemonCategory> fetchCategory(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return PokemonCategory.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load list of pokemon from $url');
    }
  }

    static Future<Types> fetchTypes(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Types.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load list of pokemon from $url');
    }
  }
}