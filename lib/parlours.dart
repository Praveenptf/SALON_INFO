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
        final services = shop['description']!
            .split(',')
            .map((s) => s.trim().toLowerCase())
            .toList();
        final shopName = shop['shopName']!.toLowerCase();
        final address = shop['address']!.toLowerCase();
        final searchQuery = query.toLowerCase();

        return shopName.contains(searchQuery) ||
            address.contains(searchQuery) ||
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
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 cards per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75, // Adjust the ratio as needed
        ),
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
    return GestureDetector(
      onTap: () {
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
                  imageUrl,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      height: 120,
                      child: Center(child: Icon(Icons.error)),
                    );
                  },
                ),
              ),
              SizedBox(height: 8),
              Text(
                shopName,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.black),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 4),
              Text(
                address,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.black),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 4),
              Text(
                contactNumber,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.black),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}