import 'dart:convert';

FavoritePokemon favoritePokemonFromJson(String str) {
  final jsonData = json.decode(str);
  return FavoritePokemon.fromMap(jsonData);
}

String favoritePokemonToJson(FavoritePokemon data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class FavoritePokemon {
  int id;
  String name;

  FavoritePokemon({
    required this.id,
    required this.name,
  });

  factory FavoritePokemon.fromMap(Map<String, dynamic> json) {
    return FavoritePokemon(
      id: json["id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
