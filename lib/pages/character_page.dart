import 'package:flutter/material.dart';
import 'package:rick_and_morty_apps/models/character.dart';
import 'package:rick_and_morty_apps/models/fav_character.dart';
import 'package:rick_and_morty_apps/pages/detail_character_page.dart';
import 'package:rick_and_morty_apps/pages/fav_pages.dart';
import 'package:rick_and_morty_apps/services/api_character.dart';
import 'package:rick_and_morty_apps/services/database_helper.dart';
import 'package:rick_and_morty_apps/widgets/character_list.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  late Future<List<Character>> charactersFuture;
  List<Character> allCharacters = [];
  List<Character> displayedCharacters = [];
  Set<int> favoriteCharacterIds = {};
  bool isSearching = false;

  @override
  void initState() {
    super.initState();

    // Fetch all character data
    charactersFuture = ApiServiceCharacter().fetchCharacters();
    charactersFuture.then((value) {
      setState(() {
        allCharacters = value;
        displayedCharacters = value;
      });
    });

    // Load favorite characters
    loadFavoriteCharacterIds();
  }

  // Filter characters by search query
  void filterCharacters(String query) {
    final filtered = allCharacters.where((character) {
      final nameLower = character.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    setState(() {
      displayedCharacters = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 56, 199, 227),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    // Greeting text
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Welcome to the\nRick and Morty\nUniverse!',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Rick",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Image decoration
                    SizedBox(
                      height: 160,
                      width: 160,
                      child: Image.asset("assets/images/bgrick.png"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title "Characters"
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      'Characters',
                      style: TextStyle(
                        color: Color(0xFF22A2BD),
                        fontSize: 16,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 5.76,
                      ),
                    ),
                  ),
                  // Buttons: Favorite and Search toggle
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavoritePage()),
                          );
                        },
                        icon: const Icon(Icons.favorite_border,
                            color: Colors.black),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isSearching = !isSearching;

                            // If closing search, reset list
                            if (!isSearching) {
                              displayedCharacters = allCharacters;
                              _searchController.clear();
                            }
                          });
                        },
                        icon: Icon(
                          isSearching ? Icons.close : Icons.search,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isSearching)
                // Search input field
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      hintStyle: TextStyle(fontFamily: "Lexend"),
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (value) {
                      filterCharacters(value);
                    },
                  ),
                ),
              // FutureBuilder for characters
              FutureBuilder<List<Character>>(
                future: charactersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show shimmer loader
                    return CharacterList(
                      characters: null,
                      isLoading: true,
                      onCharacterTap: (_) {},
                      favoriteCharacterIds: favoriteCharacterIds,
                      onFavoriteToggle: (_) {},
                    );
                  } else if (snapshot.hasData) {
                    // Show character list
                    return CharacterList(
                      characters: displayedCharacters,
                      isLoading: false,
                      favoriteCharacterIds: favoriteCharacterIds,
                      onCharacterTap: (character) {
                        // Navigate to detail character page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailCharacterPage(
                              character: character,
                              isFavorite:
                                  favoriteCharacterIds.contains(character.id),
                            ),
                          ),
                        );
                      },
                      onFavoriteToggle: (character) async {
                        // Toggle favorite status
                        setState(() {
                          if (favoriteCharacterIds.contains(character.id)) {
                            favoriteCharacterIds.remove(character.id);
                            dbHelper.deleteFavorite(character.id);
                          } else {
                            favoriteCharacterIds.add(character.id);
                            dbHelper.insertFavorite(FavoriteCharacter(
                              id: character.id,
                              name: character.name,
                              status: character.status,
                              species: character.species,
                              type: character.type,
                              gender: character.gender,
                              originName: character.origin.name,
                              locationName: character.location.name,
                              image: character.image,
                              episodeCount: character.episode.length,
                              url: character.url,
                              created: character.created.toIso8601String(),
                            ));
                          }
                        });
                      },
                    );
                  } else if (snapshot.hasError) {
                    // Error state
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Load favorite character IDs from local DB
  Future<void> loadFavoriteCharacterIds() async {
    final favorites = await dbHelper.getFavorites();
    setState(() {
      favoriteCharacterIds = favorites.map((fav) => fav.id).toSet();
    });
  }
}
