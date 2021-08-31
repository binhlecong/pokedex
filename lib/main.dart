import 'package:flutter/material.dart';
import 'package:pokedex/blocs/check_favorite.dart';
import 'package:pokedex/blocs/theme.dart';
import 'package:pokedex/screens/homescreen.dart';
import 'package:pokedex/utilities/type_of_search.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(),
    ),
    ChangeNotifierProvider<FavoriteChecker>(
      create: (_) => FavoriteChecker(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeChanger>(
      builder: (context, notifier, child) {
        return MaterialApp(
          theme: notifier.getTheme,
          title: 'Pokedex',
          debugShowCheckedModeBanner: false,
          home: HomeScreen(
            searchType: SearchTypes.byName(),
            searching: false,
          ),
        );
      },
    );
  }
}
