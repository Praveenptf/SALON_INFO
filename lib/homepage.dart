import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloon_app/profile.dart'; // Ensure ProfileScreen is imported
import 'package:saloon_app/Location.dart';
import 'package:saloon_app/slider.dart'; // Import your ImageCarousel widget

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const SizedBox(), // Placeholder for HomeScreen content
    ProfileScreen(), // Profile screen for the second tab
  ];

  @override
  void initState() {
    super.initState();
  }

  Widget _buildHomeScreen() {
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
            icon: Icon(Icons.location_on, color: Colors.white),
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
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex == 0) {
      // Show confirmation dialog
      final result = await showDialog<bool>( // Confirm exit dialog
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Exit'),
            content: Text('Do you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancel
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Exit
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      if (result == true) {
        // Exit the app
        SystemNavigator.pop();
        return false; // Prevent any additional pop action
      }
      return false; // Prevent any additional pop action
    } else {
      // Not on the home page, navigate to the home page
      setState(() {
        _currentIndex = 0; // Navigate to the home page
      });
      return false; // Prevent default back button behavior
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _currentIndex == 0 ? _buildHomeScreen() : _children[1],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: BottomNavigationBar(
            selectedIconTheme: IconThemeData(color: Colors.black),
            unselectedIconTheme: IconThemeData(color: Colors.black),
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
