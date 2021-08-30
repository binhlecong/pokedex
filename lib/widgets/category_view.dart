import 'package:flutter/material.dart';
import 'package:pokedex/api/poke_api.dart';
import 'package:pokedex/models/pokemon_categories.dart';
import 'package:pokedex/widgets/pokemon_view.dart';

class CategoryView extends StatefulWidget {
  final String url;
  final String name;

  CategoryView({Key? key, required this.url, this.name = ''}) : super(key: key);

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  late Future<PokemonCategory> pokemons;

  @override
  void initState() {
    super.initState();
    pokemons = PokeAPI.fetchCategory(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name.toUpperCase()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: FutureBuilder<PokemonCategory>(
            future: pokemons,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                  crossAxisSpacing: 20,
                  crossAxisCount: 2,
                  children: snapshot.data!.species
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              decoration:
                                  const BoxDecoration(color: Color(0x55ffffff)),
                              child: GestureDetector(
                                onTap: () {
                                  inspectPokemon(e.url);
                                },
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        getImageURL(e.url),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        e.name.toUpperCase(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String getImageURL(String url) {
    var l = url.split('/');
    l.removeWhere((element) => element == '');
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${l.last}.png';
  }

  void inspectPokemon(String url) {
    var l = url.split('/');
    l.removeWhere((element) => element == '');
    String id = l.last;
    var newurl = 'https://pokeapi.co/api/v2/pokemon/$id';
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PokemonView(url: newurl)));
  }
}
