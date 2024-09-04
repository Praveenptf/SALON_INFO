import 'package:flutter/material.dart';

class AllItemsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'All Items',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: GridView.count(
        crossAxisCount: 2, // Changed to display 2 cards per row
        padding: const EdgeInsets.all(16.0),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.8, // Adjusted aspect ratio to fit two cards per row
        children: <Widget>[
          FeaturedServiceCard(
            imageUrl: 'https://i.pinimg.com/736x/5c/57/48/5c5748d76c36d8d8a313bf3b56d79985.jpg',
            icon: Icons.star,
            title: 'Haircut',
            rating: 4.5,
            onTap: () {
              // Handle card tap
            },
          ),
          FeaturedServiceCard(
            imageUrl: 'https://thebeardclub.com/cdn/shop/articles/Trim_Your_Beard_2_3202ea96-9f43-43af-bc17-81955f6ddabc.jpg?v=1651237993&width=1920',
            icon: Icons.star,
            title: 'Beard Trim',
            rating: 4.0,
            onTap: () {
              // Handle card tap
            },
          ),
          FeaturedServiceCard(
            imageUrl: 'https://www.bodycraft.co.in/wp-content/uploads/woman-washing-head-hairsalon-600x400.jpg',
            icon: Icons.star,
            title: 'Hair Treatment',
            rating: 5.0,
            onTap: () {
              // Handle card tap
            },
          ),
          // Add more cards if needed
        ],
      ),
    );
  }
}

class FeaturedServiceCard extends StatelessWidget {
  final IconData icon;
  final String imageUrl;
  final String title;
  final double rating;
  final VoidCallback onTap;

  FeaturedServiceCard({
    required this.icon,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(
                imageUrl, // Load image from the web
                height: 110,
                width: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildStars(rating),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the list of star icons (similar to HairCard)
  List<Widget> _buildStars(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = rating - fullStars > 0;

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(
        Icons.star,
        color: Colors.amber,
        size: 20.0,
      ));
    }

    if (hasHalfStar) {
      stars.add(Icon(
        Icons.star_half,
        color: Colors.amber,
        size: 20.0,
      ));
    }

    // If you want to ensure there are always 5 stars, even if some are empty:
    while (stars.length < 5) {
      stars.add(Icon(
        Icons.star_border,
        color: Colors.amber,
        size: 20.0,
      ));
    }

    return stars;
  }
}
