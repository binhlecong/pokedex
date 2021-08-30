import 'package:pokedex/models/named_api_resource.dart';
import 'package:pokedex/models/pokemon_ability.dart';
import 'package:pokedex/models/pokemon_held_item.dart';
import 'package:pokedex/models/pokemon_move.dart';
import 'package:pokedex/models/pokemon_sprite.dart';
import 'package:pokedex/models/pokemon_stat.dart';
import 'package:pokedex/models/pokemon_type.dart';

class Converter {
  static convertToListAbility(List<dynamic> list) {
    final res = <PokemonAbility>[];
    for (var e in list) {
      res.add(PokemonAbility(
        isHidden: e['is_hidden'],
        slot: e['slot'],
        ability: Converter.convertToNamedAPIResource(e['ability']),
      ));
    }
    return res;
  }

  static convertToListNamedApiResource(List<dynamic> list) {
    final res = <NamedAPIResource>[];
    for (var e in list) {
      res.add(NamedAPIResource(
        name: e['name'],
        url: e['url'],
      ));
    }
    return res;
  }

  static convertToListHeldItem(List<dynamic> list) {
    final res = <PokemonHeldItem>[];
    for (var e in list) {
      res.add(PokemonHeldItem(
        item: Converter.convertToNamedAPIResource(e['item']),
      ));
    }
    return res;
  }

  static convertToListMove(List<dynamic> list) {
    final res = <PokemonMove>[];
    for (var e in list) {
      res.add(
        PokemonMove(
          move: Converter.convertToNamedAPIResource(e['move']),
        ),
      );
    }
    return res;
  }

  static convertToListStat(List<dynamic> list) {
    final res = <PokemonStat>[];
    for (var e in list) {
      res.add(PokemonStat(
        stat: Converter.convertToNamedAPIResource(e['stat']),
        effort: e['effort'],
        baseStat: e['base_stat'],
      ));
    }
    return res;
  }

  static convertToListPokemonType(List<dynamic> list) {
    final res = <PokemonType>[];
    for (var e in list) {
      res.add(PokemonType(
        slot: e['slot'],
        pokemon: Converter.convertToNamedAPIResource(e['pokemon']),
      ));
    }
    return res;
  }

  static convertToListType(List<dynamic> list) {
    final res = <PokemonType>[];
    for (var e in list) {
      res.add(PokemonType(
        slot: e['slot'],
        pokemon: Converter.convertToNamedAPIResource(e['type']),
      ));
    }
    return res;
  }

  static convertToNamedAPIResource(dynamic value) {
    return NamedAPIResource(
      name: value['name'],
      url: value['url'],
    );
  }

  static convertToSprite(dynamic value) {
    return PokemonSprites(
      frontDefault: value['front_default'],
      frontShiny: value['front_shiny'],
      frontFemale: value['front_female'] ?? value['front_default'],
      frontShinyFemale: value['front_shiny_female'] ?? value['front_shiny'],
      backDefault: value['back_default'],
      backShiny: value['back_shiny'],
      backFemale: value['back_female'] ?? value['back_default'],
      backShinyFemale: value['back_shiny_female'] ?? value['back_shiny'],
    );
  }
}
