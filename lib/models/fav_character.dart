class FavoriteCharacter {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String originName;
  final String locationName;
  final String image;
  final int episodeCount;
  final String url;
  final String created;

  FavoriteCharacter({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.originName,
    required this.locationName,
    required this.image,
    required this.episodeCount,
    required this.url,
    required this.created,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'originName': originName,
      'locationName': locationName,
      'image': image,
      'episodeCount': episodeCount,
      'url': url,
      'created': created,
    };
  }

  factory FavoriteCharacter.fromMap(Map<String, dynamic> map) {
    return FavoriteCharacter(
      id: map['id'],
      name: map['name'],
      status: map['status'],
      species: map['species'],
      type: map['type'],
      gender: map['gender'],
      originName: map['originName'],
      locationName: map['locationName'],
      image: map['image'],
      episodeCount: map['episodeCount'],
      url: map['url'],
      created: map['created'],
    );
  }
}
