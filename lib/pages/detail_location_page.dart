import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_apps/models/location.dart';
import 'package:shimmer/shimmer.dart';

class DetailLocationPage extends StatefulWidget {
  final Location location;

  const DetailLocationPage({super.key, required this.location});

  @override
  State<DetailLocationPage> createState() => _DetailLocationPageState();
}

class _DetailLocationPageState extends State<DetailLocationPage> {
  List<Map<String, dynamic>> residentDetails = [];
  bool isLoading = true;
  bool showAllResidents = false;

  @override
  void initState() {
    super.initState();
    // Fetch resident data
    fetchResidents();
  }

  // Fetch details
  Future<void> fetchResidents() async {
    try {
      final futures = widget.location.residents.map((url) async {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          return (json.decode(response.body) as Map<String, dynamic>);
        } else {
          return <String, dynamic>{};
        }
      }).toList();

      final results = await Future.wait(futures);
      setState(() {
        residentDetails = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching residents: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = widget.location;

    // Display only 12 residents by default
    final List<Map<String, dynamic>> displayedResidents = showAllResidents
        ? residentDetails
        : (residentDetails.length > 12
            ? residentDetails.sublist(0, 12)
            : residentDetails);

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? _buildShimmerLayout()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Background image
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        child: Image.asset(
                          "assets/images/bg_location.jpg",
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

                  // Location name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      location.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Lexend",
                        color: Color(0xFF22A2BD),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Location details
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildInfoRow("Type", location.type),
                        const SizedBox(height: 6),
                        buildInfoRow("Dimension", location.dimension),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Residents header + See More toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Text(
                          "Residents:",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Lexend",
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        if (residentDetails.length > 12)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showAllResidents = !showAllResidents;
                              });
                            },
                            child: Text(
                              showAllResidents ? "Show Less" : "See More",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontFamily: "Lexend",
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Residents grid
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
                      itemCount: displayedResidents.length,
                      itemBuilder: (context, index) {
                        final char = displayedResidents[index];
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

  // Shimmer loader while waiting for data
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

  // Shimmer loader while waiting for residents
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
