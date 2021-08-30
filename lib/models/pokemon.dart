import 'dart:core';

import 'package:pokedex/models/named_api_resource.dart';
import 'package:pokedex/models/pokemon_ability.dart';
import 'package:pokedex/models/pokemon_held_item.dart';
import 'package:pokedex/models/pokemon_move.dart';
import 'package:pokedex/models/pokemon_sprite.dart';
import 'package:pokedex/models/pokemon_stat.dart';
import 'package:pokedex/models/pokemon_type.dart';
import 'package:pokedex/utilities/convert_json.dart';


class Pokemon {
  final int id;
  final String name;
  final int baseExperience;
  final int height;
  final bool isDefault;
  final int order;
  final int weight;
  final List<PokemonAbility> abilities;
  final List<NamedAPIResource> forms;
  final List<PokemonHeldItem> heldItems;
  final String locationAreaEncounters;
  final List<PokemonMove> moves;
  final PokemonSprites sprite;
  final NamedAPIResource species;
  final List<PokemonStat> stats;
  final List<PokemonType> types;

  Pokemon({
    required this.id,
    required this.name,
    required this.baseExperience,
    required this.height,
    required this.isDefault,
    required this.order,
    required this.weight,
    required this.abilities,
    required this.forms,
    required this.heldItems,
    required this.locationAreaEncounters,
    required this.moves,
    required this.sprite,
    required this.species,
    required this.stats,
    required this.types,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // skip the game indices item
    return Pokemon(
      id: json['id'],
      name: json['name'],
      baseExperience: json['base_experience'],
      height: json['height'],
      isDefault: json['is_default'],
      order: json['order'],
      weight: json['weight'],
      abilities: Converter.convertToListAbility(json['abilities']),
      forms: Converter.convertToListNamedApiResource(json['forms']),
      heldItems: Converter.convertToListHeldItem(json['held_items']),
      locationAreaEncounters: json['location_area_encounters'],
      moves: Converter.convertToListMove(json['moves']),
      sprite: Converter.convertToSprite(json['sprites']),
      species: Converter.convertToNamedAPIResource(json['species']),
      stats: Converter.convertToListStat(json['stats']),
      types: Converter.convertToListType(json['types']),
    );
  }
}