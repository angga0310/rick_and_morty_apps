import 'package:flutter/material.dart';
import 'package:rick_and_morty_apps/models/character.dart';

class DetailCharacterPage extends StatelessWidget {
  final Character character;
  final bool isFavorite;

  const DetailCharacterPage({
    super.key,
    required this.character,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          character.name,
          style: const TextStyle(color: Colors.white, fontFamily: "Lexend"),
        ),
        backgroundColor: const Color(0xFF22A2BD),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header card
                Container(
                  color: const Color(0xFF22A2BD),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          character.location.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Lexend",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isFavorite)
                        const Icon(Icons.favorite, color: Colors.red, size: 18),
                    ],
                  ),
                ),

                // Body card: Character image + info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Character image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          character.image,
                          height: 110,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Character details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Character name
                            Text(
                              character.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Rick",
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left column
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailText(
                                          "Status", character.status),
                                      _buildDetailText(
                                          "Species", character.species),
                                      _buildDetailText(
                                        "Type",
                                        character.type.isNotEmpty
                                            ? character.type
                                            : 'Unknown',
                                      ),
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
                                          "Gender", character.gender),
                                      _buildDetailText(
                                          "Origin", character.origin.name),
                                      _buildDetailText(
                                        "Episodes",
                                        character.episode.length.toString(),
                                      ),
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

                // Footer card
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF22A2BD),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(12)),
                  ),
                  child: Text(
                    "Created: ${character.created.toLocal()}",
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
        ),
      ),
    );
  }

  // Helper method: Build detail text row
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
