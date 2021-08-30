import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_type.dart';
import 'package:pokedex/utilities/cap_ext.dart';
import 'package:pokedex/widgets/detail_line.dart';

class PokeTypes extends StatelessWidget {
  final List<PokemonType> pokeType;

  const PokeTypes({Key? key, required this.pokeType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView(
          children: pokeType
              .map((e) => DetailLine(
                    prop: e.pokemon.name.inCaps,
                    labelWidth: 200,
                  ))
              .toList()),
    );
  }
}
