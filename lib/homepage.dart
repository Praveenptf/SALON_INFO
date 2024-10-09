import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:saloon_app/Location.dart';
import 'package:saloon_app/parlours.dart';
import 'package:saloon_app/slider.dart'; // Import your ImageCarousel widget

class HomePage extends StatefulWidget {
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
  final List<Map<String, String>> parlourShops = [
    {
      'shopName': 'Glamour Beauty Salon',
      'address': 'Alappy Beauty St, Alappuzha',
      'contactNumber': '+91 6703456789',
      'description': 'Hair',
      'imageUrl': 'https://content.jdmagicbox.com/comp/alappuzha/u2/0477px477.x477.230322194815.j8u2/catalogue/p040lrdauigeji8-v9vsr95h1g.jpg?clr=',
    },
    {
      'shopName': 'Glamour Alpite',
      'address': 'Alappy Beauty St, Alappuzha',
      'contactNumber': '+91 6703456789',
      'description': 'Nails',
      'imageUrl': 'https://content.jdmagicbox.com/comp/alappuzha/u2/0477px477.x477.230322194815.j8u2/catalogue/p040lrdauigeji8-v9vsr95h1g.jpg?clr=',
    },
    {
      'shopName': 'Beauty Lounge',
      'address': 'MG Road, Kochi',
      'contactNumber': '+91 1234567890',
      'description': 'Skin',
      'imageUrl': 'https://media.istockphoto.com/id/1325440885/photo/retro-styled-beauty-salon.jpg?s=612x612&w=0&k=20&c=uEdh3ypS-Zeq9X5YJzIfBaiaoFYstRFNowZBTbQWT8I=',
    },
    {
      'shopName': 'Urban Chic Salon',
      'address': 'Linking Road, Ernakulam',
      'contactNumber': '+91 0987654321',
      'description': 'Spa',
      'imageUrl': 'https://img.freepik.com/premium-photo/beauty-salon-interior-chairs-mirrors-pink-hairdressing-shop-generative-ai-inside-beauty-studio-spa-room-clean-empty-trendy-salon-store-fashion-glamour-design-concept_788189-10319.jpg',
    },
    {
      'shopName': 'XPressions Studio',
      'address': 'Linking Road, Ernakulam',
      'contactNumber': '+91 0987654321',
      'description': 'Spa, Nails, Skin',
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROIbEGhJbL6vQPWErlalF5m8vMpZFKd15kLg&s',
    },
    {
      'shopName': 'Level-Up Salon',
      'address': 'Linking Road, Ernakulam',
      'contactNumber': '+91 0987654321',
      'description': 'Spa, Hair, Skin, Nails',
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQpcNd_c7o84c9e-swrPwKlTXle08cAqyOqg&s',
    },
  ];

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
        actions: [
          IconButton(
            icon: Icon(Icons.location_on, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Mappage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ImageCarousel(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome to Salon Info',
              style: GoogleFonts.adamina(fontSize: 24, fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: parlourShops.length,
              itemBuilder: (context, index) {
                final shop = parlourShops[index];
                return Container(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              shop['imageUrl']!,
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            shop['shopName']!,
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 4),
                          Text(
                            shop['description']!,
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 4),
                          Text(
                            shop['address']!,
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black), // Changed to black
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 4),
                          Text(
                            shop['contactNumber']!,
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black), // Changed to black
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Parlours(
                      parlourShops: parlourShops,
                      serviceFilter: '',
                    ),
                  ),
                );
              },
              child: Text('View All'),
            ),
          ),
        ],
      ),
    );
  }
}
