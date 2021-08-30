class PokemonSprites {
  String frontDefault;
  String frontShiny;
  String frontFemale;
  String frontShinyFemale;
  String backDefault;
  String backShiny;
  String backFemale;
  String backShinyFemale;

  PokemonSprites({
    required this.frontDefault,
    required this.frontShiny,
    required this.frontFemale,
    required this.frontShinyFemale,
    required this.backDefault,
    required this.backShiny,
    required this.backFemale,
    required this.backShinyFemale,
  });

  factory PokemonSprites.fromJson(Map<String, dynamic> json) {
    return PokemonSprites(
      frontDefault: json['front_default'],
      frontShiny: json['front_shiny'],
      frontFemale: json['front_female'],
      frontShinyFemale: json['front_shiny_female'],
      backDefault: json['back_default'],
      backShiny: json['back_shiny'],
      backFemale: json['back_female'],
      backShinyFemale: json['back_shiny_female'],
    );
  }

  List<String> toList() {
    List<String> l = [
      frontDefault,
      backDefault,
      frontShiny,
      backShiny,
      frontFemale,
      frontShinyFemale,
      backFemale,
      backShinyFemale,
    ];
    return l;
  }
}