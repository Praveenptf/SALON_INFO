import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloon_app/Location.dart';
import 'package:saloon_app/slider.dart'; // Import your ImageCarousel widget

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Salon Info",
          style: GoogleFonts.adamina(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
         actions: [
          IconButton(
            icon: Icon(Icons.location_on,color: Colors.white,),
            onPressed: () {
              // Navigate to the LocationPage when the location button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Mappage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header Image
            ImageCarousel(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Welcome to Salon Info',
                style: GoogleFonts.adamina(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Explore Our Services and Book your Appointment Easily',
                style: GoogleFonts.adamina(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Available Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
