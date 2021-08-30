import 'package:pokedex/models/named_api_resource.dart';

class PokemonMove {
  NamedAPIResource move;

  PokemonMove({
    required this.move,
  });

  factory PokemonMove.fromJson(Map<String, dynamic> json) {
    return PokemonMove(move: json['move']);
  }
}