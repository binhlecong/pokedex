import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_ability.dart';
import 'package:pokedex/models/pokemon_stat.dart';
import 'package:pokedex/utilities/button_widget.dart';
import 'package:pokedex/utilities/cap_ext.dart';
import 'package:pokedex/widgets/detail_line.dart';

class PokeBaseStat extends StatelessWidget {
  final List<PokemonStat> pokeStat;
  final List<PokemonAbility> pokeAbility;

  const PokeBaseStat({
    Key? key,
    required this.pokeStat,
    required this.pokeAbility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
      child: ListView(
        children: [
          ...pokeStat
              .map(
                (e) => DetailLine(
                  prop: e.stat.name.inCaps,
                  value: e.baseStat.toString(),
                  labelWidth: 200,
                ),
              )
              .toList(),
          const DetailLine(prop: 'Abilities', labelWidth: 120),
          Container(
            padding: const EdgeInsets.all(5),
            child: Wrap(
              spacing: 10,
              children: pokeAbility
                  .map(
                    (e) => SeeMoreButton(
                      label: e.ability.name.inCaps,
                      openThisURL: () {},
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
