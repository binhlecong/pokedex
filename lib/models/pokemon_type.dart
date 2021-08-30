import 'package:pokedex/models/named_api_resource.dart';
import 'package:pokedex/utilities/convert_json.dart';

class PokemonType {
  int slot;
  NamedAPIResource pokemon;

  PokemonType({
    required this.slot,
    required this.pokemon,
  });

  factory PokemonType.fromJson(Map<String, dynamic> json) {
    return PokemonType(
      slot: json['slot'],
      pokemon: json['pokemon'],
    );
  }
}

class Types {
  final int id;
  final String name;
  final List<PokemonType> pokemon;

  Types({
    required this.id,
    required this.name,
    required this.pokemon,
  });

  factory Types.fromJson(Map<String, dynamic> json) {
    return Types(
      id: json['id'],
      name: json['name'],
      pokemon: Converter.convertToListPokemonType(json['pokemon']),
    );
  }
}