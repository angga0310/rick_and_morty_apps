import 'package:flutter/material.dart';
import 'package:rick_and_morty_apps/models/location.dart';
import 'package:rick_and_morty_apps/pages/detail_location_page.dart';
import 'package:rick_and_morty_apps/services/api_location.dart';
import 'package:rick_and_morty_apps/widgets/location_list.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late Future<List<Location>> locationsFuture;
  List<Location> allLocations = [];
  List<Location> displayedLocations = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch location data
    fetchAndSetLocations();
  }

  // Fetch all locations from API
  Future<void> fetchAndSetLocations() async {
    try {
      final locations = await ApiServiceLocation().fetchLocations();
      setState(() {
        allLocations = locations;
        displayedLocations = locations;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching locations: $e");
    }
  }

  // Filter locations by search query
  void filterLocations(String query) {
    final filtered = allLocations.where((location) {
      final nameLower = location.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    setState(() {
      displayedLocations = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Locations",
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
                  hintText: "Search location...",
                  hintStyle: TextStyle(fontFamily: "Lexend"),
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: filterLocations,
              ),
            ),

            // Location list
            Expanded(
              child: LocationList(
                locations: displayedLocations,
                isLoading: isLoading,
                onLocationTap: (location) {
                  // Navigate to location detail page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailLocationPage(location: location),
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
