class NamedAPIResource {
  String name;
  String url;

  NamedAPIResource({
    required this.name,
    required this.url,
  });

  factory NamedAPIResource.fromJson(Map<String, dynamic> json) {
    return NamedAPIResource(
      name: json['name'],
      url: json['url'],
    );
  }
}