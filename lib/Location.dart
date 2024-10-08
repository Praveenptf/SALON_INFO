import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Mappage extends StatefulWidget {
  const Mappage({super.key});

  @override
  State<Mappage> createState() => _MappageState();
}

class _MappageState extends State<Mappage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Your Location"),
      ),
      body: content(),
    );
  }

  Widget content() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(9.4981, 76.3388),
        initialZoom: 11,
        minZoom: 3, // Setting minimum zoom level
        maxZoom: 18, // Setting maximum zoom level
        interactionOptions: InteractionOptions(
          flags: InteractiveFlag.all, // Enables all gestures including pinch-to-zoom
        ),
      ),
      children: [
        openStreetMapTileLayer,
        MarkerLayer(markers: [
          Marker(
            point: LatLng(9.4981, 76.3388),
            width: 60,
            height: 60,
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                // Handle tap event
              },
              child: Icon(
                Icons.location_pin,
                size: 50,
                color: Colors.red,
              ),
            ),
          )
        ]),
      ],
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);
