import 'package:flutter/material.dart';
import 'package:rick_and_morty_apps/models/fav_character.dart';
import 'package:rick_and_morty_apps/services/database_helper.dart';

class FavoritePage extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper();

  FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Favorite Characters",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Lexend",
          ),
        ),
        backgroundColor: const Color(0xFF22A2BD),
      ),
      body: FutureBuilder<List<FavoriteCharacter>>(
        future: dbHelper.getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final favorites = snapshot.data!;
            if (favorites.isEmpty) {
              // Empty state
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        "assets/images/bg_!fav.png",
                        height: 180,
                        width: 180,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No favorite characters yet!",
                      style: TextStyle(
                        fontFamily: "Lexend",
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Tap the heart icon on characters you like\nand they'll appear here.",
                      style: TextStyle(
                        fontFamily: "Lexend",
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // List of favorite characters
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final fav = favorites[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header: location name & favorite icon
                        Container(
                          color: const Color(0xFF22A2BD),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  fav.locationName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Lexend",
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Icon(Icons.favorite,
                                  color: Colors.red, size: 18),
                            ],
                          ),
                        ),

                        // Body: character image & info
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  fav.image,
                                  height: 110,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Character name
                                    Text(
                                      fav.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Rick",
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    // Two-column details
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Left column
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildDetailText(
                                                  "Status", fav.status),
                                              _buildDetailText(
                                                  "Species", fav.species),
                                              _buildDetailText(
                                                  "Type",
                                                  fav.type.isNotEmpty
                                                      ? fav.type
                                                      : 'Unknown'),
                                            ],
                                          ),
                                        ),
                                        // Right column
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildDetailText(
                                                  "Gender", fav.gender),
                                              _buildDetailText(
                                                  "Origin", fav.originName),
                                              _buildDetailText("Episodes",
                                                  fav.episodeCount.toString()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Footer: created date
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          decoration: const BoxDecoration(
                            color: Color(0xFF22A2BD),
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(12)),
                          ),
                          child: Text(
                            "Created: ${fav.created}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: "Lexend",
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            // Error state
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const SizedBox();
        },
      ),
    );
  }

  // Helper for detail text rows
  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        "$label: $value",
        style: const TextStyle(
          fontSize: 11,
          fontFamily: "Lexend",
          color: Colors.black,
        ),
      ),
    );
  }
}
