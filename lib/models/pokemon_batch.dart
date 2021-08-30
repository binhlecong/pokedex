import 'package:pokedex/models/named_api_resource.dart';
import 'package:pokedex/utilities/convert_json.dart';

class PokemonBatch {
  int count;
  String next;
  String previous;
  List<NamedAPIResource> results;

  PokemonBatch({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory PokemonBatch.fromJson(Map<String, dynamic> json) {
    return PokemonBatch(
      count: json['count'],
      next: json['next'] ?? 'null',
      previous: json['previous'] ?? 'null',
      results: Converter.convertToListNamedApiResource(json['results']),
    );
  }
}