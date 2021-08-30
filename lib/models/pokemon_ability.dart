import 'package:pokedex/models/named_api_resource.dart';

class PokemonAbility {
  bool isHidden;
  int slot;
  NamedAPIResource ability;

  PokemonAbility({
    required this.isHidden,
    required this.slot,
    required this.ability,
  });

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(
      isHidden: json['isHidden'],
      slot: json['slot'],
      ability: json['ability'],
    );
  }
}