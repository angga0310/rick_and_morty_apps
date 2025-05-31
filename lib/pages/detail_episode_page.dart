import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_apps/models/episode.dart';
import 'package:shimmer/shimmer.dart';

class DetailEpisodePage extends StatefulWidget {
  final Episode episode;

  const DetailEpisodePage({super.key, required this.episode});

  @override
  State<DetailEpisodePage> createState() => _DetailEpisodePageState();
}

class _DetailEpisodePageState extends State<DetailEpisodePage> {
  List<Map<String, dynamic>> characterDetails = [];
  bool isLoading = true;
  bool showAllCharacters = false;

  @override
  void initState() {
    super.initState();
    // Fetch all character data for this episode
    fetchCharacters();
  }

  // Fetch details of each character in the episode
  Future<void> fetchCharacters() async {
    try {
      final futures = widget.episode.characters.map((url) async {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          return (json.decode(response.body) as Map<String, dynamic>);
        } else {
          return <String, dynamic>{}; // fallback for failed requests
        }
      }).toList();

      final results = await Future.wait(futures);
      setState(() {
        characterDetails = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching character details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final episode = widget.episode;

    // Show only 12 first characters by default
    final List<Map<String, dynamic>> displayedCharacters = showAllCharacters
        ? characterDetails
        : (characterDetails.length > 12
            ? characterDetails.sublist(0, 12)
            : characterDetails);

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? _buildShimmerLayout()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poster image
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        child: Image.asset(
                          "assets/images/poster_movie.jpg",
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Back button
                      Positioned(
                        top: 16,
                        left: 16,
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.7),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Episode name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      episode.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Lexend",
                        color: Color(0xFF22A2BD),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Episode info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildInfoRow("Episode", episode.episode),
                        const SizedBox(height: 6),
                        buildInfoRow("Air Date", episode.airDate),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Characters header + See More toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Text(
                          "Characters:",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Lexend",
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        if (characterDetails.length > 12)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showAllCharacters = !showAllCharacters;
                              });
                            },
                            child: Text(
                              showAllCharacters ? "Show Less" : "See More",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontFamily: "Lexend",
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Characters grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      itemCount: displayedCharacters.length,
                      itemBuilder: (context, index) {
                        final char = displayedCharacters[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            char['image'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Info row for episode details
  Widget buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(
            fontSize: 12,
            fontFamily: "Lexend",
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Lexend",
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  // Shimmer loader while waiting for data
  Widget _buildShimmerLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 20,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 60,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: 12,
              itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
