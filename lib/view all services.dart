import 'package:flutter/material.dart';

class Services extends StatelessWidget {
  final Map<String, List<Map<String, String>>> serviceItems;
  final String selectedCategory;

  const Services({
    super.key,
    required this.serviceItems,
    required this.selectedCategory,
  });
  

  @override
  Widget build(BuildContext context) {
    // Filter service items by the selected category
    final filteredItems = serviceItems[selectedCategory] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$selectedCategory Services',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: _buildServiceRows(filteredItems),
        ),
      ),
    );
  }

  List<Widget> _buildServiceRows(List<Map<String, String>> items) {
    List<Widget> rows = [];
    
    for (int i = 0; i < items.length; i += 2) {
      // Create a row for two items
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildServiceCard(items[i])),
            if (i + 1 < items.length) // Check for the second item
              SizedBox(width: 30), // Space between cards
            if (i + 1 < items.length) // Check for the second item
              Expanded(child: _buildServiceCard(items[i + 1])),
          ],
        ),
      );
      rows.add(SizedBox(height: 10)); // Space between rows
    }

    return rows;
  }

  Widget _buildServiceCard(Map<String, String> service) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        
      ),
      elevation: 4.0,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
            child: Image.network(
              service['imageUrl'] ?? '',
              height: 120,
              width: 138, // Use full width
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['title'] ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (service['price'] != null)
                  Text(
                    service['price']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
