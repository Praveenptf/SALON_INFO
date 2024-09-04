import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloon_app/All%20items.dart';
import 'package:saloon_app/parlours.dart';
import 'package:saloon_app/slider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showAllCards = true;

  get title => null;

  get imageUrl => null; // Set to true to show cards

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
            icon: Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle favorite icon button tap
              // You can add functionality here, like navigating to a favorites page or updating state
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
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  ServiceCategory(
                    icon: Icons.cut,
                    label: 'Hair & Beard',
                    destinationPage: Parlours(
                        serviceFilter: 'Hair Cut'), // Pass 'Hair Cut' filter
                  ),
                  ServiceCategory(
                    icon: Icons.brush,
                    label: 'Nails',
                    destinationPage:
                        Parlours(serviceFilter: 'Nails'), // Pass 'Nails' filter
                  ),
                  ServiceCategory(
                    icon: Icons.face,
                    label: 'Skin',
                    destinationPage:
                        Parlours(serviceFilter: 'Skin'), // Pass 'Skin' filter
                  ),
                  ServiceCategory(
                    icon: Icons.spa,
                    label: 'Spa',
                    destinationPage:
                        Parlours(serviceFilter: 'Spa'), // Pass 'Spa' filter
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Most Viewed',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllItemsScreen()),
                      );
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Square Shape Cards in Grid Layout
            Container(
              height: 300, // Adjust height as needed
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _showAllCards
                  ? GridView.count(
                      crossAxisCount: 2, // Changed to 2 cards per row
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      childAspectRatio:
                          0.8, // Adjusted to fit two cards per row
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: <Widget>[
                        FeaturedServiceCard(
                          imageUrl:
                              'https://i.pinimg.com/736x/5c/57/48/5c5748d76c36d8d8a313bf3b56d79985.jpg',
                          icon: Icons.star,
                          title: 'Haircut',
                          rating: 4,
                          onTap: () {
                            // Handle card tap
                          },
                        ),
                        FeaturedServiceCard(
                          imageUrl:
                              'https://thebeardclub.com/cdn/shop/articles/Trim_Your_Beard_2_3202ea96-9f43-43af-bc17-81955f6ddabc.jpg?v=1651237993&width=1920',
                          icon: Icons.star,
                          title: 'Beard Trim',
                          rating: 4.0,
                          onTap: () {
                            // Handle card tap
                          },
                        ),
                      ],
                    )
                  : Center(child: Text('No cards to display')),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCategory extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget destinationPage;

  ServiceCategory({
    required this.icon,
    required this.label,
    required this.destinationPage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
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

