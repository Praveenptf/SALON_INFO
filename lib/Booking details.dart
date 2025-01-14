import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saloon_app/Cart.dart';
import 'package:saloon_app/Cartmodel.dart';
import 'package:saloon_app/Confirm_page.dart';
import 'package:saloon_app/Token.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:saloon_app/view%20all%20services.dart';

class BookingPage extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String shopName;
  final String shopAddress;
  final String contactNumber;
  final String description;
  final int id;

  const BookingPage({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.shopName,
    required this.shopAddress,
    required this.contactNumber,
    required this.description,
    required this.id, required parlourDetails,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isAvailable = true;
  final Set<String> selectedServiceTitles = {};
  bool isLoading = false;
  int get shopId => widget.id;
  List<Map<String, dynamic>> services = [];

 void addToCart(BuildContext context, Map<String, dynamic> service) {
  // Add the service to the cart
  Provider.of<CartModel>(context, listen: false).addItem({
    'title': service['itemName'],
    'price': service['price'].toString(),
    'imageUrl': service['imageUrl'] ?? '', // Ensure you have an image URL
  });

    selectedServiceTitles.add(service['itemName']!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${service['itemName']} added to cart!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  double _calculateTotalAmount() {
    double total = 0.0;
    for (var item in Provider.of<CartModel>(context, listen: false).cartItems) {
      String priceString = item['price'] ?? '0.0';
      double price = double.tryParse(priceString) ?? 0.0;
      int quantity = int.tryParse(item['quantity'] ?? '1') ?? 1;
      total += price * quantity;
    }
    return total;
  }

  int _calculateTotalQuantity() {
    int totalQuantity = 0;
    for (var item in Provider.of<CartModel>(context, listen: false).cartItems) {
      int quantity = int.tryParse(item['quantity'] ?? '1') ?? 1;
      totalQuantity += quantity;
    }
    return totalQuantity;
  }

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

 Future<void> _fetchServices() async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.1.39:8080/parlour/$shopId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        // Assuming the services are in the first item of the response
        if (jsonResponse.isNotEmpty && jsonResponse[0]['items'] != null) {
          // Cast the items to List<Map<String, dynamic>>
          services = List<Map<String, dynamic>>.from(jsonResponse[0]['items'].map((service) {
            return {
              'itemName': service['itemName'],
              'price': service['price'],
              'description': service['description'],
              'availability': service['availability'],
              'serviceTime': service['serviceTime'],
              // 'itemImage': service['itemImage'], // If you want to display images
            };
          }));
        } else {
          services = []; // Set to empty list if no services are available
        }
      });
    } else {
      throw Exception('Failed to load services');
    }
  } catch (e) {
    print('Error fetching services: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching services: $e'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

  Future<void> _bookAppointment() async {
    setState(() {
      isLoading = true;
    });

    String? token = await TokenManager.getToken();

    List<Map<String, dynamic>> bookingData = [
      {
        "user Id": 7,
        "itemId": 5,
        "itemName": selectedServiceTitles.join(', '),
        "actualPrice": _calculateTotalAmount(),
        "parlourId": shopId,
        "parlourName": widget.shopName,
        "employeeId": 3,
        "employeeName": "Sheena",
        "quantity": _calculateTotalQuantity(),
        "bookingDate": DateFormat('yyyy-MM-dd').format(selectedDate!),
        "bookingTime": DateFormat('HH:mm:ss').format(
            DateTime(2020, 1, 1, selectedTime!.hour, selectedTime!.minute, 00)),
      }
    ];

    final response = await http.post(
      Uri.parse('http://192.168.1.39:8080/api/cart/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(bookingData),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('Appointment booked successfully!');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmationPage(
            selectedServices: Provider.of<CartModel>(context, listen: false).cartItems,
            selectedDate: selectedDate!,
            selectedTime: selectedTime!,
            customerName: '',
            contactNumber: '',
            orderId: '',
            paymentId: '',
            uniqueId: '',
          ),
        ),
      );
    } else {
      print('Failed to book appointment: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to book appointment: ${response.body}'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     appBar: AppBar(
  title: Text(
    widget.title,
    style: GoogleFonts.adamina(color: Colors.deepPurple.shade800),
  ),
  backgroundColor: Colors.white,
  iconTheme: IconThemeData(color: Colors.deepPurple.shade800),
  actions: [
    Consumer<CartModel>(
      builder: (context, cart, child) => Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.deepPurple.shade800),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartItems: cart.cartItems),
                ),
              );
            },
          ),
          if (cart.cartItems.isNotEmpty)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  '${cart.cartItems.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    ),
  ],
),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            _buildSectionTitle('Shop Information'),
            Column(
              children: [
                ListTile(
                  title: Text(widget.shopName,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple.shade800)),
                  subtitle: Text(widget.shopAddress, style: TextStyle(color: Colors.black87)),
                ),
                ListTile(
                  title: Text(widget.contactNumber, style: TextStyle(color:Colors.black87)),
                  subtitle: Text(widget.description, style: TextStyle(color: Colors.black87)),
                ),
                ListTile(
                  title: Text('Shop id: ${shopId}', style: TextStyle(color:Colors.black87)),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                _buildSectionTitle('Available Services'),
                 Padding(
  padding: const EdgeInsets.only(left: 150),
  child: TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServicePage(services: services ), // Pass the services here
        ),
      );
    },
    child: Text(
      'View All',
      style: TextStyle(
        color: Colors.deepPurple.shade400,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
),
              ],
            ),
            _buildServiceList(),
            SizedBox(height: 20),
            _buildSectionTitle('Booking Time'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateTimePicker(
                  'Date',
                  selectedDate != null
                      ? DateFormat.yMMMd().format(selectedDate!)
                      : 'Select Date',
                  () => _selectDate(context),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showSpinnerTimePicker(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple.shade800,),
                          borderRadius: BorderRadius.circular(20),
                           gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple.shade400,
                                Colors.deepPurple.shade800,
                              ],
                            ),
                        ),
                        child: Text(
                          selectedTime != null
                              ? DateFormat.jm().format(DateTime(2020, 1, 1,
                                  selectedTime!.hour, selectedTime!.minute, 00))
                              : 'Select Time',
                          style: TextStyle(fontSize: 15, color : Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Availability'),
            Text(
              isAvailable
                  ? 'The shop is available at this time.'
                  : 'The shop is not available at this time.',
              style: TextStyle(
                  fontSize: 16,
                  color: isAvailable ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                decoration: BoxDecoration(
                   gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple.shade400,
                                Colors.deepPurple.shade800,
                              ],
                            ),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                width: 300,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                    backgroundColor: Colors.deepPurple.shade800,
                    foregroundColor:Colors.deepPurple.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: isAvailable && selectedDate != null && selectedTime != null && !isLoading
                      ? () async {
                          await _bookAppointment();
                        }
                      : null,
                  child: isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 69, 39, 160)),
                        )
                      : const Text('Book Now', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
 Widget _buildServiceList() {
  return GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(), // Prevent scrolling
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // Number of items in a row
      crossAxisSpacing: 8.0, // Spacing between items horizontally
      mainAxisSpacing: 8.0, // Spacing between items verticallys
      childAspectRatio: 0.65, // Adjusted aspect ratio to prevent overflow
    ),
    itemCount: services.length,
    itemBuilder: (context, index) {
      final service = services[index];
      return Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white, // Background color for the container
          borderRadius: BorderRadius.circular(8.0), // Rounded edges
       boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder or actual image
            Container(
              height: 100, // Adjusted height
              width: double.infinity, // Full width of the parent container
              decoration: BoxDecoration(
                color: Colors.grey[500], // Placeholder color
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Icon(Icons.image, color: Colors.white, size: 50),
              ),
            ),
            Flexible(
              child: Text(
                service['itemName'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1, // Limit text to one line
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              '\$${service['price']}',
              style: TextStyle(color: Colors.black, fontSize: 14.0),
            ),
            SizedBox(height: 4.0),
            Flexible(
              child: Text(
                service['description'],
                style: TextStyle(color: Colors.black, fontSize: 12.0),
                maxLines: 2, // Limit to two lines
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              'Available: ${service['availability'] ? 'Yes' : 'No'}',
              style: TextStyle(color: Colors.black, fontSize: 12.0),
            ),
            SizedBox(height: 4.0),
            Text(
              'Service Time: ${service['serviceTime']}',
              style: TextStyle(color: Colors.black, fontSize: 12.0),
            ),
            SizedBox(height: 8.0), // Reduced space above the button
            Container(
              width: double.infinity, // Ensure button spans the container width
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
              ),
              child: ElevatedButton(
                onPressed: () {
                  addToCart(context, service);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Button color
                ),
                child: Text('Add to Cart', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    },
  );
}




  Widget _buildDateTimePicker(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.black)),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20),
               gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple.shade400,
                                Colors.deepPurple.shade800,
                              ],
                            ),),
            child: Text(value, style: TextStyle(fontSize: 15, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showSpinnerTimePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: ( BuildContext context) {
        return AlertDialog(
          title: Text('Select Time'),
          content: Container(
            height: 200,
            child: TimePickerSpinner(
              is24HourMode: false,
              normalTextStyle: TextStyle(fontSize: 20, color: Colors.black),
              highlightedTextStyle: TextStyle(
                  fontSize: 24, color: Colors.deepPurple.shade800),
              spacing: 20,
              itemHeight: 40,
              onTimeChange: (time) {
                setState(() {
                  selectedTime = TimeOfDay.fromDateTime(time);
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }
} 