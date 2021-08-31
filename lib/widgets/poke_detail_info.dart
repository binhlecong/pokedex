import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/widgets/poke_about.dart';
import 'package:pokedex/widgets/poke_base_stat.dart';
import 'package:pokedex/widgets/poke_moves.dart';

class PokeDetailInfo extends StatefulWidget {
  final Pokemon myPoke;

  const PokeDetailInfo({Key? key, required this.myPoke}) : super(key: key);

  @override
  _PokeDetailInfoState createState() => _PokeDetailInfoState();
}

class _PokeDetailInfoState extends State<PokeDetailInfo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        children: [
          TabBar(
            unselectedLabelColor: const Color(0x55000000),
            labelColor: Theme.of(context).hintColor,
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(
                text: 'About',
              ),
              Tab(
                text: 'Base stat.',
              ),
              Tab(
                text: 'Moves',
              )
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                PokeAbout(
                  species: widget.myPoke.species.name,
                  height: widget.myPoke.height.toDouble(),
                  weight: widget.myPoke.weight.toDouble(),
                  baseExp: widget.myPoke.baseExperience.toInt(),
                  heldItems: widget.myPoke.heldItems,
                  types: widget.myPoke.types,
                ),
                PokeBaseStat(
                  pokeStat: widget.myPoke.stats,
                  pokeAbility: widget.myPoke.abilities,
                ),
                PokeMoves(
                  pokeMove: widget.myPoke.moves,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
