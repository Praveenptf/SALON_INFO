import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';

class Mappage extends StatefulWidget {
  const Mappage({super.key});

  @override
  State<Mappage> createState() => _MappageState();
}

class _MappageState extends State<Mappage> {
  LatLng? _tappedLocation; // Store tapped location
  TextEditingController _searchController = TextEditingController(); // Controller for search text
  LatLng _mapCenter = LatLng(9.4981, 76.3388); // Initial center of the map
  double _zoomLevel = 11.0;
  late MapController _mapController; // Controller to move the map

  @override
  void initState() {
    super.initState();
    _mapController = MapController(); // Initialize map controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Your Location"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search location',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _searchLocation(value); // Call search location on submit
                }
              },
            ),
          ),
          Expanded(child: content()), // Map widget below the search bar
        ],
      ),
    );
  }

  Widget content() {
    return FlutterMap(
      mapController: _mapController, // Assign the map controller
      options: MapOptions(
        minZoom: _zoomLevel,
        interactionOptions: InteractionOptions(
          flags: InteractiveFlag.all,
        ),
        onTap: (tapPosition, point) {
          setState(() {
            _tappedLocation = point; // Set tapped location
          });
        },
      ),
      children: [
        openStreetMapTileLayer,
        MarkerLayer(markers: [
          if (_tappedLocation != null) // Check if a location is tapped
            Marker(
              point: _tappedLocation!,
              width: 60,
              height: 60,
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  // Handle marker tap event
                },
                child: Icon(
                  Icons.location_pin,
                  size: 50,
                  color: Colors.red,
                ),
              ),
            ),
        ]),
      ],
    );
  }

  Future<void> _searchLocation(String query) async {
    final url =
        "https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);
        LatLng searchedLocation = LatLng(lat, lon);

        setState(() {
          _tappedLocation = searchedLocation; // Set the tapped location marker
          _mapController.move(searchedLocation, 13.0); // Move the map to the new location
        });
      }
    } else {
      // Handle error
      print("Failed to load location data");
    }
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
