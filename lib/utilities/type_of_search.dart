class SearchTypes {
  static String byName() => 'name';
  static String byColors() => 'color';
  static String byHabitats() => 'habitat';
  static String byShapes() => 'shape';
  static String byTypes() => 'type';

  static List<String> getAllType() =>
      ['name', 'color', 'habitat', 'shape', 'type'];
}

const Map<String, String> searchUrls = {
  'name': 'https://pokeapi.co/api/v2/pokemon/',
  'color': 'https://pokeapi.co/api/v2/pokemon-color/',
  'habitat': 'https://pokeapi.co/api/v2/pokemon-habitat/',
  'shape': 'https://pokeapi.co/api/v2/pokemon-shape/',
  'type': 'https://pokeapi.co/api/v2/type/',
};


const Map<String, String> hintTexts = {
  'name': 'pikachu',
  'color': 'yellow',
  'habitat': 'forest',
  'shape': 'quadruped',
  'type': 'electric',
};
