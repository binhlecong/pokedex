import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/api/poke_api.dart';
import 'package:pokedex/blocs/check_favorite.dart';
import 'package:pokedex/database/db_models.dart';
import 'package:pokedex/database/favorite_pokemon_db.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/widgets/poke_detail_info.dart';
import 'package:provider/provider.dart';

class PokemonView extends StatefulWidget {
  final String url;

  const PokemonView({Key? key, required this.url}) : super(key: key);

  @override
  _PokemonViewState createState() => _PokemonViewState();
}

class _PokemonViewState extends State<PokemonView> {
  late Future<Pokemon> pokemon;

  @override
  void initState() {
    super.initState();
    pokemon = PokeAPI.fetchPokemonByURL(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pokemon>(
      future: pokemon,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int id = snapshot.data!.id;
          String name = snapshot.data!.name;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                name.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                Consumer<FavoriteChecker>(
                  builder: (context, checker, _) {
                    return IconButton(
                      onPressed: () {
                        if (checker.isFavorite) {
                          _deleteFromFavorite(id);
                        } else {
                          _addToFavorite(id, name);
                        }
                      },
                      icon: Builder(
                        builder: (context) {
                          checker.checkFavorite(id);

                          if (checker.isFavorite) {
                            return Icon(Icons.star, color: Colors.amber);
                          } else {
                            return Icon(Icons.star_outline_rounded);
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/pokemon_bg.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 250,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayInterval: const Duration(seconds: 10),
                    ),
                    items: snapshot.data!.sprite.toList().map((e) {
                      return Builder(builder: (BuildContext context) {
                        return Image.network(
                          e,
                          fit: BoxFit.fill,
                        );
                      });
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: PokeDetailInfo(myPoke: snapshot.data!),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
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
    );
  }

  void _addToFavorite(int id, String name) {
    FavoritePokemonDB.db.newPokemon(FavoritePokemon(id: id, name: name));
  }

  void _deleteFromFavorite(int id) {
    FavoritePokemonDB.db.deleteFavoritePokemon(id);
  }
}
