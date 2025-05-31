import 'package:flutter/material.dart';
import 'package:rick_and_morty_apps/models/character.dart';
import 'package:shimmer/shimmer.dart';

class CharacterList extends StatelessWidget {
  final List<Character>? characters;
  final bool isLoading;
  final Function(Character) onCharacterTap;
  final Set<int> favoriteCharacterIds;
  final Function(Character) onFavoriteToggle;

  const CharacterList({
    super.key,
    required this.characters,
    required this.onCharacterTap,
    required this.favoriteCharacterIds,
    required this.onFavoriteToggle,
    this.isLoading = false,
  });

  // Utility: get only first two words of a name
  String getFirstTwoWords(String text) {
    final words = text.split(' ');
    if (words.length <= 2) {
      return text;
    } else {
      return '${words[0]} ${words[1]}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: isLoading ? 6 : characters!.length,
      itemBuilder: (context, index) {
        if (isLoading) {
          // Show shimmer loading effect
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 160,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: 80,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 12,
                  width: 60,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ],
            ),
          );
        }

        final character = characters![index];
        final isFavorite = favoriteCharacterIds.contains(character.id);

        // Main character card
        return GestureDetector(
          onTap: () => onCharacterTap(character),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  // Character image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      character.image,
                      width: 160,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Favorite icon overlay
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => onFavoriteToggle(character),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Character name (first two words)
              Text(
                getFirstTwoWords(character.name),
                style: const TextStyle(
                  color: Color(0xFF22A2BD),
                  fontFamily: "Rick",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              // Character species & status
              Text(
                '${character.species}, ${character.status}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
