import 'package:pokedex/models/named_api_resource.dart';

class PokemonStat {
  NamedAPIResource stat;
  int effort;
  int baseStat;

  PokemonStat({
    required this.stat,
    required this.effort,
    required this.baseStat,
  });

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      stat: json['stat'],
      effort: json['effort'],
      baseStat: json['baseStat'],
    );
  }
}