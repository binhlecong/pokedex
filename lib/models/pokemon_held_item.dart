import 'package:pokedex/models/named_api_resource.dart';

class PokemonHeldItem {
  NamedAPIResource item;

  PokemonHeldItem({
    required this.item,
  });

  factory PokemonHeldItem.fromJson(Map<String, dynamic> json) {
    return PokemonHeldItem(item: json['item']);
  }
}