import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloon_app/Location.dart';
import 'package:saloon_app/parlours.dart';
import 'package:saloon_app/slider.dart'; // Import your ImageCarousel widget

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> recentlyViewedShops = [];

  // Call this function when a parlour is viewed
  void addRecentlyViewed(Map<String, String> parlour) {
    setState(() {
      recentlyViewedShops.removeWhere((shop) =>
          shop['shopName'] == parlour['shopName']); // Remove duplicates
      recentlyViewedShops.insert(
          0, parlour); // Add to the beginning of the list
      if (recentlyViewedShops.length > 5) {
        recentlyViewedShops.removeLast(); // Keep the list to a maximum of 5 items
      }
    });
  }

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
            SizedBox(height: 10),
            // Service Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: // Replace the service categories with actual parlour details
                  GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  ServiceCategory(
                    icon: Icons.cut,
                    label: 'Hair & Beard',
                    serviceFilter: 'Hair',
                    parlourDetails: {
                      'shopName': 'Glamour Beauty Salon',
                      'address': 'Alappy Beauty St, Alappuzha',
                      'contactNumber': '+91 6703456789',
                      'description': 'Hair Cut',
                      'imageUrl':
                          'https://content.jdmagicbox.com/comp/alappuzha/u2/0477px477.x477.230322194815.j8u2/catalogue/p040lrdauigeji8-v9vsr95h1g.jpg?clr=',
                    },
                    onViewed: addRecentlyViewed,
                  ),
                  ServiceCategory(
                    icon: Icons.brush,
                    label: 'Nails',
                    serviceFilter: 'Nails',
                    parlourDetails: {
                      'shopName': 'Glamour Alpite',
                      'address': 'Alappy Beauty St, Alappuzha',
                      'contactNumber': '+91 6703456789',
                      'description': 'Nails',
                      'imageUrl':
                          'https://content.jdmagicbox.com/comp/alappuzha/u2/0477px477.x477.230322194815.j8u2/catalogue/p040lrdauigeji8-v9vsr95h1g.jpg?clr=',
                    },
                    onViewed: addRecentlyViewed,
                  ),
                  ServiceCategory(
                    icon: Icons.face,
                    label: 'Skin',
                    serviceFilter: 'Skin',
                    parlourDetails: {
                      'shopName': 'Beauty Lounge',
                      'address': 'MG Road, Kochi',
                      'contactNumber': '+91 1234567890',
                      'description': 'Skin',
                      'imageUrl':
                          'https://media.istockphoto.com/id/1325440885/photo/retro-styled-beauty-salon.jpg?s=612x612&w=0&k=20&c=uEdh3ypS-Zeq9X5YJzIfBaiaoFYstRFNowZBTbQWT8I=',
                    },
                    onViewed: addRecentlyViewed,
                  ),
                  ServiceCategory(
                    icon: Icons.spa,
                    label: 'Spa',
                    serviceFilter: 'Spa',
                    parlourDetails: {
                      'shopName': 'Urban Chic Salon',
                      'address': 'Linking Road, Ernakulam',
                      'contactNumber': '+91 0987654321',
                      'description': 'Spa',
                      'imageUrl':
                          'https://img.freepik.com/premium-photo/beauty-salon-interior-chairs-mirrors-pink-hairdressing-shop-generative-ai-inside-beauty-studio-spa-room-clean-empty-trendy-salon-store-fashion-glamour-design-concept_788189-10319.jpg',
                    },
                    onViewed: addRecentlyViewed,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Recently Viewed Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Recently Viewed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            recentlyViewedShops.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: recentlyViewedShops.map((shop) {
                        return RecentlyViewedCard(shop: shop);
                      }).toList(),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'No recently viewed parlours yet.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ServiceCategory extends StatelessWidget {
  final IconData icon;
  final String label;
  final String serviceFilter;
  final Function(Map<String, String>) onViewed;
  final Map<String, String> parlourDetails; // Add parlour details parameter

  ServiceCategory({
    required this.icon,
    required this.label,
    required this.serviceFilter,
    required this.onViewed,
    required this.parlourDetails, // Initialize it
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add to recently viewed with actual parlour details
        onViewed(parlourDetails);

        // Navigate to the Parlours page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Parlours(serviceFilter: serviceFilter),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 40.0, color: Colors.white),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentlyViewedCard extends StatelessWidget {
  final Map<String, String> shop;

  RecentlyViewedCard({required this.shop});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Image.network(
          shop['imageUrl']!,
          width: 50,

          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(shop['shopName']!),
        subtitle: Text(shop['address']!),
        onTap: () {
          // Navigate to booking details or another page
        },
      ),
    );
  }
}
