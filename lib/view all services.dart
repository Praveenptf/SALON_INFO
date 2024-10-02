import 'package:flutter/material.dart';
import 'package:saloon_app/cart%20page.dart';

class Services extends StatefulWidget {
  final Map<String, List<Map<String, String>>> serviceItems;
  final String selectedCategory;

  const Services({
    super.key,
    required this.serviceItems,
    required this.selectedCategory,
  });

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  List<Map<String, String>> _cartItems = [];
  List<int> _selectedIndices = [];

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.serviceItems[widget.selectedCategory] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.selectedCategory} Services',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: _showCart,
          ),
         
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: _buildServiceRows(filteredItems),
        ),
      ),
    );
  }

  void _showCart() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CartPage(cartItems: _cartItems),
      ),
    );
  }

  void _addSelectedToCart() {
    setState(() {
      final filteredItems = widget.serviceItems[widget.selectedCategory] ?? [];
      for (var index in _selectedIndices) {
        _cartItems.add(filteredItems[index]);
      }
      _selectedIndices.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected items added to cart!')));
  }

  List<Widget> _buildServiceRows(List<Map<String, String>> items) {
    List<Widget> rows = [];

    for (int i = 0; i < items.length; i += 2) {
      List<Widget> rowChildren = [];

      rowChildren.add(Expanded(child: _buildServiceCard(items[i], i)));

      if (i + 1 < items.length) {
        rowChildren.add(SizedBox(width: 30));
        rowChildren.add(Expanded(child: _buildServiceCard(items[i + 1], i + 1)));
      } else {
        rowChildren.add(SizedBox(width: 30));
        rowChildren.add(Expanded(child: Container()));
      }

      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: rowChildren,
      ));

      rows.add(SizedBox(height: 10));
    }

    return rows;
  }

Widget _buildServiceCard(Map<String, String> service, int index) {
  const double cardWidth = 170.0; // Fixed width
  const double cardHeight = 170.0; // Fixed height (adjust as needed)
  bool isSelected = _selectedIndices.contains(index);

  return GestureDetector(
    onTap: () {
      setState(() {
        if (isSelected) {
          _selectedIndices.remove(index);
        } else {
          _selectedIndices.add(index);
        }
      });
    },
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: isSelected ? 8.0 : 4.0,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: cardHeight * 0.65, // Adjust this ratio as needed
                width: cardWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                  image: DecorationImage(
                    image: NetworkImage(service['imageUrl'] ?? ''), // Placeholder URL
                    fit: BoxFit.cover, // Ensure this is set to 'cover'
                  ),
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
          Positioned(
            bottom: -10,
            right: 5,
            child: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              color: Colors.black,
              iconSize: 24,
              onPressed: () {
                _showConfirmationDialog(service);
              },
            ),
          ),
        ],
      ),
    ),
  );
}





void _showConfirmationDialog(Map<String, String> service) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add to Cart'),
        content: Text('Are you sure you want to add "${service['title']}" to the cart?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Confirm'),
            onPressed: () {
              setState(() {
                _cartItems.add(service);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${service['title']} added to cart!')),
              );
            },
          ),
        ],
      );
    },
  );
}
}

