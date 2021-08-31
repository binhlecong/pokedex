import 'package:flutter/material.dart';
import 'package:pokedex/database/db_models.dart';
import 'package:pokedex/database/favorite_pokemon_db.dart';
import 'package:pokedex/utilities/type_of_search.dart';
import 'package:pokedex/widgets/error_notif.dart';
import 'package:pokedex/widgets/pokemon_view.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<FavoritePokemon>> favPokemons;

  @override
  void initState() {
    super.initState();
    favPokemons = FavoritePokemonDB.db.getAllFavoritePokemons();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Favorite Pokemons"),
        ),
        body: FutureBuilder<List<FavoritePokemon>>(
          future: favPokemons,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                  crossAxisCount: 2,
                  children:
                      snapshot.data!.map((e) => _buildPokemonTile(e)).toList());
            } else if (snapshot.hasError) {
              return ErrorNotif(error: snapshot.error.toString());
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Padding _buildPokemonTile(FavoritePokemon e) {
    var url = "${searchUrls['name']}${e.name}";

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0x25000000),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            _inspect(url, e.name);
          },
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<String>(
                  future: _getImageURL(e.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Image.network(
                        snapshot.data!,
                        fit: BoxFit.fill,
                      );
                    } else if (snapshot.hasError) {
                      return const Icon(Icons.error);
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  e.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _inspect(String url, String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PokemonView(url: url);
        },
      ),
    );
  }

  Future<String> _getImageURL(int id) async {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  }
}
