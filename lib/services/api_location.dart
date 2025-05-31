import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_apps/models/location.dart';
import 'package:rick_and_morty_apps/services/api.dart';

class ApiServiceLocation {
  final http.Client client;

  ApiServiceLocation({http.Client? client}) : client = client ?? http.Client();

  // Fetch all locations (first page by default)
  Future<List<Location>> fetchLocations() async {
    final response = await client.get(Uri.parse(Api.dataLocation));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Location.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }

  // Search locations by name
  Future<List<Location>> searchLocations(String name) async {
    final response =
        await client.get(Uri.parse('${Api.dataLocation}?name=$name'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Location.fromJson(json)).toList();
    } else {
      // No results found -> empty list
      return [];
    }
  }
}
