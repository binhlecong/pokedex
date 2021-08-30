import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/api/poke_api.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/widgets/poke_detail_info.dart';

class PokemonView extends StatefulWidget {
  final String url;
  PokemonView({Key? key, required this.url}) : super(key: key);

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
          return Scaffold(
            appBar: AppBar(
              title: Text(
                snapshot.data!.name.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
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
}
