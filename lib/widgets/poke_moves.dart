import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_move.dart';
import 'package:pokedex/utilities/button_widget.dart';

class PokeMoves extends StatelessWidget {
  final List<PokemonMove> pokeMove;

  const PokeMoves({Key? key, required this.pokeMove}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var buttonColor = MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        return Theme.of(context).secondaryHeaderColor;
      },
    );

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SingleChildScrollView(
        child: Wrap(
            spacing: 15,
            children: pokeMove
                .map((e) => SeeMoreButton(
                      label: e.move.name,
                      buttonColor: buttonColor,
                      openThisURL: () {},
                    ))
                .toList()),
      ),
    );
  }
}
