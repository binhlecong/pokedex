import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_held_item.dart';
import 'package:pokedex/models/pokemon_type.dart';
import 'package:pokedex/utilities/button_widget.dart';
import 'package:pokedex/utilities/cap_ext.dart';
import 'package:pokedex/widgets/detail_line.dart';

class PokeAbout extends StatelessWidget {
  final String species;
  final double height;
  final double weight;
  final int baseExp;
  final List<PokemonHeldItem> heldItems;
  final List<PokemonType> types;

  const PokeAbout({
    Key? key,
    required this.species,
    required this.height,
    required this.weight,
    required this.baseExp,
    required this.heldItems,
    required this.types,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
      child: ListView(
        children: [
          DetailLine(
            prop: 'Species',
            value: species.inCaps,
            labelWidth: 120,
          ),
          DetailLine(
            prop: 'Base Exp.',
            value: baseExp.toString(),
            labelWidth: 120,
          ),
          DetailLine(
            prop: 'Height',
            value: (height / 10).toString(),
            labelWidth: 120,
            unit: 'm',
          ),
          DetailLine(
            prop: 'Weight',
            value: (weight / 10).toString(),
            labelWidth: 120,
            unit: 'kg',
          ),
          const DetailLine(prop: 'Types', labelWidth: 120),
          Container(
            padding: const EdgeInsets.all(5),
            child: Wrap(
              spacing: 10,
              children: types
                  .map((e) => SeeMoreButton(
                        label: e.pokemon.name.inCaps,
                        openThisURL: () {},
                      ))
                  .toList(),
            ),
          ),
          const DetailLine(prop: 'Held items', labelWidth: 120),
          Container(
            padding: const EdgeInsets.all(5),
            child: Wrap(
              spacing: 10,
              children: heldItems.isNotEmpty
                  ? heldItems
                      .map((e) => SeeMoreButton(
                            label: e.item.name.inCaps,
                            openThisURL: () {},
                          ))
                      .toList()
                  : [
                      RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.clear,
                                color: Colors.red.shade400,
                                size: 18,
                              ),
                            ),
                            TextSpan(
                              text: 'None',
                              style: TextStyle(
                                color: Colors.red.shade400,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
            ),
          ),
        ],
      ),
    );
  }
}
