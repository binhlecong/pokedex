// https://pokeapi.co/docs/v2#pokemon-colors
import 'package:pokedex/models/named_api_resource.dart';
import 'package:pokedex/utilities/convert_json.dart';

class PokemonCategory {
  final int id;
  final String name;

  final List<NamedAPIResource> species;

  PokemonCategory({
    required this.id,
    required this.name,
    required this.species,
  });

  PokemonCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        species =
            Converter.convertToListNamedApiResource(json['pokemon_species']);
}
