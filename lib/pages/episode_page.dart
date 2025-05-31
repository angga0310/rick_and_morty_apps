import 'package:flutter/material.dart';
import 'package:rick_and_morty_apps/models/episode.dart';
import 'package:rick_and_morty_apps/pages/detail_episode_page.dart';
import 'package:rick_and_morty_apps/services/api_episode.dart';
import 'package:rick_and_morty_apps/widgets/episode_list.dart';

class EpisodePage extends StatefulWidget {
  const EpisodePage({super.key});

  @override
  State<EpisodePage> createState() => _EpisodePageState();
}

class _EpisodePageState extends State<EpisodePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Episode> allEpisodes = [];
  List<Episode> displayedEpisodes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch episodes
    fetchAndSetEpisodes();
  }

  // Fetch all episodes from API
  Future<void> fetchAndSetEpisodes() async {
    try {
      final episodes = await ApiServiceEpisode().fetchEpisodes();
      setState(() {
        allEpisodes = episodes;
        displayedEpisodes = episodes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching episodes: $e');
    }
  }

  // Filter episodes by search query
  void filterEpisodes(String query) {
    final filtered = allEpisodes.where((episode) {
      final nameLower = episode.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    setState(() {
      displayedEpisodes = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Episodes",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Lexend",
          ),
        ),
        backgroundColor: const Color(0xFF22A2BD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            Container(
              margin: const EdgeInsets.only(bottom: 16),
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
                  hintText: "Search episode...",
                  hintStyle: TextStyle(fontFamily: "Lexend"),
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: filterEpisodes,
              ),
            ),

            // Episode list
            Expanded(
              child: EpisodeList(
                episodes: displayedEpisodes,
                isLoading: isLoading,
                onEpisodeTap: (ep) {
                  // Navigate to episode detail page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailEpisodePage(episode: ep),
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
}
