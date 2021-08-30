import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pokedex/api/poke_api.dart';
import 'package:pokedex/models/named_api_resource.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_batch.dart';
import 'package:pokedex/models/pokemon_categories.dart';
import 'package:pokedex/models/pokemon_type.dart';
import 'package:pokedex/utilities/cap_ext.dart';
import 'package:pokedex/utilities/type_of_search.dart';
import 'package:pokedex/widgets/category_view.dart';
import 'package:pokedex/widgets/error_notif.dart';
import 'package:pokedex/widgets/pokemon_view.dart';
import 'package:pokedex/widgets/type_view.dart';

class HomeScreen extends StatefulWidget {
  final String url;
  final String searchType;
  final bool searching;
  static const routeName = '/HomeScreen';

  HomeScreen({
    Key? key,
    this.url = 'https://pokeapi.co/api/v2/pokemon/',
    required this.searchType,
    required this.searching,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<PokemonBatch> pokemons;
  late FocusNode searchNode;
  TextEditingController textController = TextEditingController();
  bool isSearchOpen = false;

  @override
  void initState() {
    super.initState();

    searchNode = FocusNode();

    if (widget.searching) {
      switch (widget.searchType) {
        case 'color':
        case 'habitat':
        case 'shape':
          pokemons = fetchCategory(widget.url, widget.searchType);
          break;
        case 'type':
          pokemons = fetchType(widget.url, widget.searchType);
          break;
        case 'name':
        default:
          pokemons = fetchSinglePokemon(widget.url);
          break;
      }
    } else {
      pokemons = PokeAPI.fetchListPokemon(url: widget.url);
    }
  }

  @override
  void dispose() {
    searchNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            _buildBody(context),
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<PokemonBatch>(
      future: pokemons,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return SliverGrid.count(
            crossAxisCount: 2,
            children: snapshot.data!.results
                .map((e) => _buildPokemonTile(e))
                .toList(),
          );
        } else if (snapshot.hasError) {
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                ErrorNotif(error: snapshot.error.toString()),
                TextButton(
                  onPressed: () {
                    searchNode.requestFocus();
                  },
                  child: const Text(
                    "RETRY",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          );
        }
        return SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  FutureBuilder<PokemonBatch> _buildBottomNavBar(BuildContext context) {
    return FutureBuilder<PokemonBatch>(
      future: pokemons,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: IconButton(
                    iconSize: 40,
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(Icons.navigate_before),
                    color: snapshot.data!.previous == 'null'
                        ? Colors.grey.shade300
                        : Colors.black54,
                    onPressed: () {
                      if (snapshot.data!.previous != 'null') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              url: snapshot.data!.previous,
                              searchType: SearchTypes.byName(),
                              searching: false,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    iconSize: 40,
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(Icons.navigate_next),
                    color: snapshot.data!.next == 'null'
                        ? Colors.grey.shade300
                        : Colors.black54,
                    onPressed: () {
                      if (snapshot.data!.next != 'null') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              url: snapshot.data!.next,
                              searchType: SearchTypes.byName(),
                              searching: false,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) return const SizedBox(height: 1);
        return Row(
          children: const [
            Expanded(child: Icon(Icons.more_horiz)),
            Expanded(child: Icon(Icons.more_horiz)),
          ],
        );
      },
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      // snap: true,
      // floating: true,
      expandedHeight: 200,
      flexibleSpace: OverflowBox(
        maxHeight: 200,
        child: FlexibleSpaceBar(
          background: Image.asset(
            'assets/images/pokemon_logo.png',
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      centerTitle: true,
      title: const Text("A comprehensive dictionary"),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              isSearchOpen = !isSearchOpen;
              Future.delayed(const Duration(milliseconds: 500), () {
                if (isSearchOpen) searchNode.requestFocus();
              });
            });
          },
          icon: const Icon(Icons.search),
        )
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 45),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: SearchTypes.getAllType()
                .map((e) => Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 7),
                      width: 90,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(5),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          primary: e == widget.searchType
                              ? Colors.white
                              : Colors.white38,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                url: searchUrls[e]!,
                                searchType: e,
                                searching: false,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          e.inCaps,
                          style: TextStyle(
                            color: e != widget.searchType
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Padding _buildPokemonTile(NamedAPIResource e) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 10, 0),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0x25000000),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            inspect(e.url, e.name);
          },
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<String>(
                  future: getImageURL(e.url),
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

  void inspect(String url, String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          switch (widget.searchType) {
            case 'name':
              return PokemonView(url: url);
            case 'color':
            case 'habitat':
            case 'shape':
              return CategoryView(url: url, name: name);
            case 'type':
            default:
              return TypeView(url: url, name: name);
          }
        },
      ),
    );
  }

  Future<String> getImageURL(String url) async {
    try {
      List<String> l;
      switch (widget.searchType) {
        case 'name':
          l = url.split('/');
          l.removeWhere((element) => element == '');
          break;

        case 'color':
        case 'habitat':
        case 'shape':
          PokemonCategory pokemons = await PokeAPI.fetchCategory(url);
          var ll = pokemons.species[0].url;
          l = ll.split('/');
          l.removeWhere((element) => element == '');
          break;

        case 'type':
        default:
          Types pokemons = await PokeAPI.fetchTypes(url);
          var ll = pokemons.pokemon[0].pokemon.url;
          l = ll.split('/');
          l.removeWhere((element) => element == '');
          break;
      }
      return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${l.last}.png';
    } catch (e) {
      throw Exception('Error while fetching thumbnail');
    }
  }

  Future<PokemonBatch> fetchSinglePokemon(String _url) async {
    try {
      var l = widget.url.split('/');
      l.removeWhere((element) => element == '');
      String name = l.last;

      Pokemon getIdFromThis = await PokeAPI.fetchPokemonByURL(_url);
      String newurl = 'https://pokeapi.co/api/v2/pokemon/${getIdFromThis.id}';

      var res = NamedAPIResource(name: name, url: newurl);
      var batch = PokemonBatch(
          count: 1, next: 'null', previous: 'null', results: [res]);
      return batch;
    } catch (e) {
      throw "This pokemon doesn't exist";
    }
  }

  Future<PokemonBatch> fetchCategory(String _url, String _type) async {
    try {
      var l = widget.url.split('/');
      l.removeWhere((element) => element == '');
      String name = l.removeLast();

      PokemonCategory getIdFromThis = await PokeAPI.fetchCategory(_url);

      String newurl = searchUrls[_type]! + getIdFromThis.id.toString();
      var res = NamedAPIResource(name: name, url: newurl);
      var batch = PokemonBatch(
          count: 1, next: 'null', previous: 'null', results: [res]);
      return batch;
    } catch (e) {
      throw "This pokemon doesn't exist";
    }
  }

  Future<PokemonBatch> fetchType(String _url, String _type) async {
    try {
      var l = widget.url.split('/');
      l.removeWhere((element) => element == '');
      String name = l.removeLast();

      Types getIdFromThis = await PokeAPI.fetchTypes(_url);

      String newurl = searchUrls[_type]! + getIdFromThis.id.toString();
      var res = NamedAPIResource(name: name, url: newurl);
      var batch = PokemonBatch(
          count: 1, next: 'null', previous: 'null', results: [res]);
      return batch;
    } catch (e) {
      throw "This pokemon doesn't exist";
    }
  }
}
