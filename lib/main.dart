import 'package:flutter/material.dart';
import 'package:pokedex/blocs/theme.dart';
import 'package:pokedex/screens/homescreen.dart';
import 'package:pokedex/utilities/type_of_search.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeChanger(),
      child: Consumer<ThemeChanger>(
        builder: (context, ThemeChanger notifier, child) {
          return MaterialApp(
            title: 'Pokedex',
            debugShowCheckedModeBanner: false,
            home: HomeScreen(
              searchType: SearchTypes.byName(),
              searching: false,
            ),
          );
        },
      ),
    );
  }
}
