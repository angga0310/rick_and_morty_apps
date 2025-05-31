import 'package:flutter/material.dart';
import 'package:rick_and_morty_apps/models/location.dart';
import 'package:shimmer/shimmer.dart';

class LocationList extends StatelessWidget {
  final List<Location>? locations;
  final bool isLoading;
  final Function(Location) onLocationTap;

  const LocationList({
    super.key,
    required this.locations,
    required this.onLocationTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: isLoading ? 6 : locations!.length,
      itemBuilder: (context, index) {
        if (isLoading) {
          // Shimmer loading placeholder
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shimmer for image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Shimmer teks name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 120,
                    height: 14,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Shimmer teks dimension
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 80,
                    height: 12,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        }

        final location = locations![index];

        // Card data
        return GestureDetector(
          onTap: () => onLocationTap(location),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image location
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/images/bg_location.jpg",
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 6),
              // Name and dimension
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "Lexend",
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      location.dimension,
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: "Lexend",
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
