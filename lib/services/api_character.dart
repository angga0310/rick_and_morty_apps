import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_apps/models/character.dart';
import 'package:rick_and_morty_apps/services/api.dart';

class ApiServiceCharacter {
  final http.Client client;

  ApiServiceCharacter({http.Client? client}) : client = client ?? http.Client();

  // Fetch all characters
  Future<List<Character>> fetchCharacters() async {
    final response = await client.get(Uri.parse(Api.dataCharacter));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }

  // Search characters by name
  Future<List<Character>> searchCharacters(String name) async {
    final response =
        await client.get(Uri.parse('${Api.dataCharacter}?name=$name'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Character.fromJson(json)).toList();
    } else {
      // No results found
      return [];
    }
  }
}
