import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.place),
        title: const Text(
          'Set Destination',
          style: TextStyle(fontSize: 14),
        ),
        elevation: 2,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: _controller,
              googleAPIKey: 'AIzaSyC4qWsyH6qTuBJLUB5CQHWHAMZINCEXXGBA', // Insert your Google API key here
              inputDecoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 14),
                prefixIcon: Icon(Icons.place),
                border: OutlineInputBorder(),
                hintText: 'Enter Your Destination',
              ),
              debounceTime: 600, // Time in milliseconds to debounce API requests
              countries: const ["us", "ng"], // Add country restrictions (optional)
              isLatLngRequired: true, // Set true if you need lat/lng of the place
              getPlaceDetailWithLatLng: (Prediction prediction) {
                print("Place ID: ${prediction.placeId}");
                print("Description: ${prediction.description}");
              },
              itemClick: (Prediction prediction) {
                _controller.text = prediction.description!;
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: prediction.description!.length),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
