import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_apps/models/episode.dart';
import 'package:rick_and_morty_apps/services/api.dart';

class ApiServiceEpisode {
  final http.Client client;

  ApiServiceEpisode({http.Client? client}) : client = client ?? http.Client();

  // Fetch all episodes (first page by default)
  Future<List<Episode>> fetchEpisodes() async {
    final response = await client.get(Uri.parse(Api.dataEpisode));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Episode.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load episodes');
    }
  }

  // Search episodes by name
  Future<List<Episode>> searchEpisodes(String name) async {
    final response =
        await client.get(Uri.parse('${Api.dataEpisode}/?name=$name'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Episode.fromJson(json)).toList();
    } else {
      // No results found -> empty list
      return [];
    }
  }
}
