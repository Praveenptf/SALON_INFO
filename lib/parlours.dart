import 'package:flutter/material.dart';

import 'package:saloon_app/Booking%20details.dart';

class Parlours extends StatefulWidget {
  final String serviceFilter;
  final List<Map<String, String>> parlourShops;

  const Parlours({
    Key? key,
    required this.serviceFilter,
    required this.parlourShops,
  }) : super(key: key);

  @override
  _ParloursState createState() => _ParloursState();
}

class _ParloursState extends State<Parlours> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> filteredShops = [];
  bool isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    _filterShops(); // Initialize filtered shops
  }

  void _filterShops([String query = '']) {
    setState(() {
      filteredShops = widget.parlourShops.where((shop) {
        final services = shop['description']!.split(',').map((s) => s.trim().toLowerCase()).toList();
        final shopName = shop['shopName']!.toLowerCase();
        final address = shop['address']!.toLowerCase();
        final searchQuery = query.toLowerCase();

        return shopName.contains(searchQuery) || address.contains(searchQuery) || 
               services.any((service) => service.contains(searchQuery));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearchVisible
            ? TextField(
                controller: searchController,
                decoration: const InputDecoration(hintText: 'Search...'),
                onChanged: _filterShops,
              )
            : Text('Parlours - ${widget.serviceFilter}'),
        actions: [
          IconButton(
            icon: Icon(isSearchVisible ? Icons.clear : Icons.search),
            onPressed: () {
              setState(() {
                isSearchVisible = !isSearchVisible;
                if (!isSearchVisible) {
                  searchController.clear();
                  _filterShops(); // Reset filtered shops when search is closed
                }
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
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
    Key? key,
    required this.shopName,
    required this.address,
    required this.contactNumber,
    required this.description,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
            Text(shopName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(address, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('Contact: $contactNumber', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(description, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
                      description: description,
                      parlourDetails: {},
                    ),
                  ),
                );
              },
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }
}
