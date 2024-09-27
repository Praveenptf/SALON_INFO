import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  final List<Map<String, String>> cartItems;

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('No items in the cart.'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Image.network(item['imageUrl'] ?? '', width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item['title'] ?? ''),
                  subtitle: Text(item['price'] ?? ''),
                );
              },
            ),
    );
  }
}
