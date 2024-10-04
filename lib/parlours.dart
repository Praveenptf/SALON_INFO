import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloon_app/Booking%20details.dart';

class Parlours extends StatefulWidget {
  final String serviceFilter;

  const Parlours({super.key, required this.serviceFilter});

  @override
  _ParloursState createState() => _ParloursState();
}

class _ParloursState extends State<Parlours> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> parlourShops = [];
  List<Map<String, String>> filteredShops = [];
  bool isSearchVisible = false; // Track visibility of the search field

  @override
  void initState() {
    super.initState();
    parlourShops = [
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
        'description': 'Spa,Nails,Skin',
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROIbEGhJbL6vQPWErlalF5m8vMpZFKd15kLg&s',
      },
      {
        'shopName': 'Level-Up Salon',
        'address': 'Linking Road, Ernakulam',
        'contactNumber': '+91 0987654321',
        'description': 'Spa,Hair,Skin,Nails',
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQpcNd_c7o84c9e-swrPwKlTXle08cAqyOqg&s',
      },
    ];

    // Initially filter based on the serviceFilter passed to the constructor
    filteredShops = parlourShops.where((shop) {
      final services = shop['description']!.split(',');
      return services.any((service) => service.trim().toLowerCase() == widget.serviceFilter.toLowerCase());
    }).toList();
  }

  void _filterShops(String query) {
    setState(() {
      filteredShops = parlourShops.where((shop) {
        final shopName = shop['shopName']!.toLowerCase();
        final address = shop['address']!.toLowerCase();
        final services = shop['description']!.split(',').map((s) => s.trim().toLowerCase()).toList();
        final contact = shop['contactNumber']!.toLowerCase();
        final searchQuery = query.toLowerCase();

        // Filter only the shops that match the selected service filter
        return (shopName.contains(searchQuery) ||
                address.contains(searchQuery) ||
                services.any((service) => service.contains(searchQuery)) ||
                contact.contains(searchQuery)) &&
               services.contains(widget.serviceFilter.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: isSearchVisible
            ? TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Enter search term',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  _filterShops(value);
                },
              )
            : Text(
                'Parlours - ${widget.serviceFilter}',
                style: GoogleFonts.adamina(color: Colors.white),
              ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(isSearchVisible ? Icons.clear : Icons.search), // Toggle icon based on visibility
            onPressed: () {
              setState(() {
                if (isSearchVisible) {
                  searchController.clear();
                  _filterShops(''); // Reset the filtered list
                  isSearchVisible = false;
                } else {
                  isSearchVisible = true;
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: filteredShops.length,
          itemBuilder: (context, index) {
            final shop = filteredShops[index];
            return ParlourShopCard(
              shopName: shop['shopName']!,
              address: shop['address']!,
              contactNumber: shop['contactNumber']!,
              description: shop['description']!,
              imageUrl: shop['imageUrl']!,
            );
          },
        ),
      ),
    );
  }
}

class ParlourShopCard extends StatelessWidget {
  final String shopName;
  final String address;
  final String contactNumber;
  final String description;
  final String imageUrl;

  const ParlourShopCard({
    super.key,
    required this.shopName,
    required this.address,
    required this.contactNumber,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                imageUrl,
                height: 170,
                width: double.maxFinite,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              shopName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              address,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Contact: $contactNumber',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () { 
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingPage(
                      imageUrl: imageUrl,
                      title: shopName,
                      shopName: shopName,
                      shopAddress: address,
                      contactNumber: contactNumber,
                      description: description, parlourDetails: {},
                    ),
                                  ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            ),
            child: const Text('View Details'),
          ),
        ],
      ),
    ),
  );
}
}
