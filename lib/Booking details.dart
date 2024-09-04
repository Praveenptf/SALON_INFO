import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String shopName;
  final String shopAddress;
  final String contactNumber;
  final String description;

  const BookingPage({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.shopName,
    required this.shopAddress,
    required this.contactNumber,
    required this.description,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isAvailable = true;
  final Set<String> selectedServiceTitles =
      {}; // Use a Set to track selected services

  // Define service items for each category
  final Map<String, List<Map<String, String>>> serviceItems = {
    'Hair Cut': [
      {
        'title': 'Classic Haircut',
        'imageUrl':
            'https://hips.hearstapps.com/esq.h-cdn.co/assets/17/29/1600x800/landscape-1500667303-es-072117-talk-to-your-barber-about-your-hair.jpg?resize=1200:*'
      },
      {
        'title': 'Beard Trim',
        'imageUrl':
            'https://i0.wp.com/therighthairstyles.com/wp-content/uploads/2021/09/7-low-fade-haircut.jpg?resize=500%2C570'
      },
    ],
    'Spa': [
      {
        'title': 'Relaxing Massage',
        'imageUrl':
            'https://cdn-ikppclh.nitrocdn.com/CueiRbtmHDfiLNmOiFYzPbGQWoFHcYmP/assets/images/optimized/rev-a083d28/www.bodycraft.co.in/wp-content/uploads/beautiful-african-woman-smiling-enjoying-massage-spa-resort-scaled.jpg'
      },
      {
        'title': 'Hot Stone Therapy',
        'imageUrl':
            'https://www.bellacollina.com/hs-fs/hubfs/Spa/Massage%20with%20Male-1.jpg?width=1590&name=Massage%20with%20Male-1.jpg'
      },
    ],
    'Skin': [
      {
        'title': 'Facial Treatment',
        'imageUrl':
            'https://limelitesalonandspa.com/wp-content/uploads/2023/07/Skin-transformation-for-Women-1.jpg'
      },
      {
        'title': 'Acne Removal',
        'imageUrl':
            'https://www.apothecopharmacy.com/wp-content/uploads/2021/01/blog-4-featured-image.jpg'
      },
    ],
    'Nails': [
      {
        'title': 'Manicure',
        'imageUrl':
            'https://5.imimg.com/data5/SELLER/Default/2023/7/322795582/NT/SZ/ND/192559465/nail-extension-in-east-delhi-png-500x500.png'
      },
      {
        'title': 'Pedicure',
        'imageUrl':
            'https://cdn-ikppclh.nitrocdn.com/CueiRbtmHDfiLNmOiFYzPbGQWoFHcYmP/assets/images/optimized/rev-a083d28/www.bodycraft.co.in/wp-content/uploads/beautician-massaging-hand-female-spa-salon-client-spa-treatment-product-female-feet-hand-spa.jpg'
      },
    ],
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _checkAvailability();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        _checkAvailability();
      });
    }
  }

  void _checkAvailability() {
    if (selectedTime == null || selectedDate == null) {
      isAvailable = false;
      setState(() {});
      return;
    }

    final businessHours = {
      DateTime.monday: [9, 18],
      DateTime.tuesday: [9, 18],
      DateTime.wednesday: [9, 18],
      DateTime.thursday: [9, 18],
      DateTime.friday: [9, 18],
      DateTime.saturday: [10, 16],
      DateTime.sunday: [10, 14],
    };

    final hours = businessHours[selectedDate!.weekday] ?? [0, 0];
    final startHour = hours[0];
    final endHour = hours[1];

    isAvailable =
        selectedTime!.hour >= startHour && selectedTime!.hour < endHour;
    setState(() {});
  }

  void _bookAppointment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking Confirmed'),
        content: Text(
            'Your booking for ${widget.title} at ${widget.shopName} has been confirmed for the following services: ${selectedServiceTitles.join(', ')}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentServiceItems = serviceItems[widget.description] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking - ${widget.title}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(widget.shopAddress),
                ),
                ListTile(
                  title: Text(widget.contactNumber),
                  subtitle: Text(widget.description),
                ),
              ],
            ),
            Divider(),
            _buildSectionTitle('${widget.description} Services'),
            _buildServiceCards(currentServiceItems),
            SizedBox(height: 20),
            Divider(),
            _buildSectionTitle('Booking Time'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateTimePicker(
                    'Date',
                    selectedDate != null
                        ? DateFormat.yMMMd().format(selectedDate!)
                        : 'Pick a date',
                    () => _selectDate(context)),
                _buildDateTimePicker(
                    'Time',
                    selectedTime != null
                        ? selectedTime!.format(context)
                        : 'Pick a time',
                    () => _selectTime(context)),
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
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: isAvailable &&
                        selectedDate != null &&
                        selectedTime != null &&
                        selectedServiceTitles.isNotEmpty
                    ? _bookAppointment
                    : null,
                child: Text('Book Now'),
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
        style: GoogleFonts.adamina(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildDateTimePicker(
      String label, String value, VoidCallback onPressed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(backgroundColor: Colors.black),
          child: Text(
            value,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCards(List<Map<String, String>> items) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          final isSelected = selectedServiceTitles.contains(item['title']);
          return AnimatedScale(
            scale: isSelected ? 1.1 : 1.0, // Scale up if selected
            duration: Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedServiceTitles.remove(item['title']);
                  } else {
                    selectedServiceTitles.add(item['title']!);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  elevation: isSelected ? 8.0 : 4.0,
                  color: isSelected ? Colors.black : Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12.0)),
                        child: Image.network(
                          item['imageUrl'] ?? '',
                          height: 120,
                          width: 138,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item['title'] ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
