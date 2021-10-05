import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pokedex/api/poke_api.dart';
import 'package:pokedex/models/named_api_resource.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_batch.dart';
import 'package:pokedex/models/pokemon_categories.dart';
import 'package:pokedex/models/pokemon_type.dart';
import 'package:pokedex/screens/favoritescreen.dart';
import 'package:pokedex/screens/settingscreen.dart';
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

  const HomeScreen({
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
        drawer: _buildDrawer(),
        body: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            _buildBody(context),
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(context),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.yellow.shade700,
              image: const DecorationImage(
                image: AssetImage('assets/images/pokeball.png'),
                fit: BoxFit.fitWidth,
                alignment: FractionalOffset(0.1, 0.1),
              ),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  child: Opacity(
                    opacity: 0.5,
                    child: Container(
                      color: Colors.yellow.shade700,
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: Image.asset(
                    'assets/images/slogan.png',
                    width: 200,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: const Text("A comprehensive Pokemon dictionary"),
            alignment: Alignment.center,
          ),
          ListTile(
            leading: const Icon(Icons.star_rounded),
            title: const Text('Favorite'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text('Setting'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingScreen()),
              );
            },
          ),
        ],
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
        return const SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(),
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
          return Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            height: 40,
            child: Row(
              children: [
                _buildBottomNavButton(
                  snapshot.data!.previous,
                  Icons.navigate_before_rounded,
                ),
                _buildBottomNavButton(
                  snapshot.data!.next,
                  Icons.navigate_next_rounded,
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return const SizedBox(height: 1);
        }
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
      title: const Text("PokeDex"),
      actions: [
        IconButton(
          onPressed: () async {
            String? query = await _asyncInputDialog(context);
            if (query == null || query.isEmpty) {
              // show snackbar
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PokemonView(
                  url: searchUrls['name']! + query,
                ),
              ),
            );
          },
          icon: const Icon(Icons.search_rounded),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.now_widgets_rounded),
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

  Future _asyncInputDialog(BuildContext context) async {
    String text = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          title: const Center(child: Text('Find your pokemon')),
          content: Expanded(
            child: TextField(
              autofocus: true,
              onChanged: (value) {
                text = value;
              },
              style: const TextStyle(fontSize: 16),
              cursorHeight: 20,
              decoration: const InputDecoration(
                hintText: 'e.g. "pikachu", "1"',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(text);
              },
              child: Text(
                'GO',
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).highlightColor,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildBottomNavButton(String nextUrl, IconData icon) {
    return Expanded(
      child: IconButton(
        iconSize: 40,
        padding: const EdgeInsets.all(0),
        icon: Icon(icon),
        color: nextUrl != 'null'
            ? Theme.of(context).highlightColor
            : Theme.of(context).disabledColor,
        onPressed: () {
          if (nextUrl != 'null') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  url: nextUrl,
                  searchType: SearchTypes.byName(),
                  searching: false,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Padding _buildPokemonTile(NamedAPIResource e) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0x50505050),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            _inspect(e.url, e.name);
          },
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<String>(
                  future: _getImageURL(e.url),
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
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontWeight: FontWeight.w500,
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

  Future<String> _getImageURL(String url) async {
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
