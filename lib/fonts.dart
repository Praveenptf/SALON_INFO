// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/rendering.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:saloon_app/Location.dart';
// import 'package:saloon_app/parlours.dart';
// import 'package:saloon_app/slider.dart';
// import 'package:saloon_app/Booking%20details.dart';
// import 'package:saloon_app/profile.dart';

// class HomePage extends StatefulWidget {
//   final List<dynamic> initialNearbyParlours;

//   HomePage({Key? key, this.initialNearbyParlours = const []}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
//   List<dynamic> _nearbyParlours = [];
//   bool _isLoading = true;
//   bool _isAppBarVisible = true;
//   TextEditingController searchController = TextEditingController();
//   late ScrollController _scrollController;
//   final FocusNode _searchFocusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     _nearbyParlours = widget.initialNearbyParlours;
//     _scrollController = ScrollController();
//     _scrollController.addListener(_onScroll);
//     _searchFocusNode.addListener(() {
//       if (!_searchFocusNode.hasFocus) {
//         searchController.clear();
//       }
//     });
//   }

//   void _onScroll() {
//     if (_scrollController.position.userScrollDirection ==
//         ScrollDirection.reverse) {
//       if (_isAppBarVisible) {
//         setState(() {
//           _isAppBarVisible = false;
//         });
//       }
//     } else if (_scrollController.position.userScrollDirection ==
//         ScrollDirection.forward) {
//       if (!_isAppBarVisible) {
//         setState(() {
//           _isAppBarVisible = true;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     _searchFocusNode.dispose();
//     super.dispose();
//   }

//   void _onLocationSelected(LatLng location, List<dynamic> nearbyParlours) {
//     setState(() {
//       _nearbyParlours = nearbyParlours;
//       _isLoading = false; // Set loading to false once data is received
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> _pages = [
//       Scaffold(
//         backgroundColor: Colors.black,
//         appBar: _isAppBarVisible
//             ? AppBar(
//                 toolbarHeight: 125,
//                 backgroundColor: const Color(0XFFCA7CD8),
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Salon Info",
//                           style: GoogleFonts.adamina(
//                             fontSize: 25,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.location_on, color: Colors.white),
//                           onPressed: () async {
//                             await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => Mappage(
//                                   onLocationSelected: _onLocationSelected,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     GestureDetector(
//                       onTap: () {
//                         // Search functionality
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         padding:
//                             EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                         child: Row(
//                           children: [
//                             Icon(Icons.search, color: Colors.black),
//                             SizedBox(width: 10),
//                             Expanded(
//                               child: Text(
//                                 ' Search...',
//                                 style: TextStyle(
//                                     color: Colors.black, fontSize: 20),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//                 automaticallyImplyLeading: false,
//               )
//             : null,
//         body: ListView(
//           controller: _scrollController,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 SizedBox(height: 10),
//                 ImageCarousel(),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     'Welcome to Salon Info',
//                     style: GoogleFonts.adamina(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Text(
//                     'Explore Our Services and Book your Appointment Easily',
//                     style:
//                         GoogleFonts.adamina(fontSize: 14, color: Colors.white),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Nearby Services',
//                         style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => Parlours(
//                                 serviceFilter: searchController.text,
//                                 parlourShops: [],
//                               ),
//                             ),
//                           );
//                         },
//                         child: Text('View All',
//                             style: TextStyle(color: const Color(0XFFCA7CD8))),
//                       ),
//                     ],
//                   ),
//                 ),
//               SizedBox(height: 10),

// if (_isLoading)
//   Center(
//     child: CircularProgressIndicator(),
//   )
// else ...[
//   GridView.builder(
//     shrinkWrap: true,
//     physics: NeverScrollableScrollPhysics(),
//     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//       crossAxisCount: 2, // Two items per row
//       childAspectRatio: 1, // Square shape
//       crossAxisSpacing: 10,
//       mainAxisSpacing: 10,
//     ),
//     itemCount: _nearbyParlours.length,
//   itemBuilder: (context, index) {
//   final parlour = _nearbyParlours[index];
//   String? base64Image = parlour['imageBase64'];

//   // Check if base64Image is valid
//   ImageProvider imageProvider;
//   if (base64Image != null && base64Image.startsWith('data:image/')) {
//     final String base64Data = base64Image.split(',')[1];
//     imageProvider = MemoryImage(base64Decode(base64Data));
//   } else {
//     imageProvider = NetworkImage('https://example.com/placeholder.png'); // Placeholder URL
//   }

//   return Container(
//     height: 400,
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(15),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black26,
//           blurRadius: 4,
//           offset: Offset(0, 2),
//         ),
//       ],
//     ),
//     child: Column(
//       children: [
//         Container(
//           height: 10,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: imageProvider,
//               fit: BoxFit.cover,
//             ),
//             borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
//           ),
//         ),
//         SizedBox(height: 8.0),
//         ListTile(
//           title: Text(
//             parlour['parlourName'] ?? 'Unknown Parlour', // Using null-coalescing to avoid null
//             style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold),
//           ),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Phone: ${parlour['phoneNumber'] ?? 'No Phone Available'}',
//                 style: TextStyle(color: Colors.black54),
//               ),
//               Text(
//                 'Location: ${parlour['location'] ?? 'No Location Available'}',
//                 style: TextStyle(color: Colors.black54),
//               ),
//               Text(
//                 'Description: ${parlour['description'] ?? 'No Description Available'}',
//                 style: TextStyle(color: Colors.black54),
//               ),
//               Text(
//                 'Ratings: ${parlour['ratings'] ?? 'No Ratings'}',
//                 style: TextStyle(color: Colors.black54),
//               ),
//             ],
//           ),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => BookingPage(
//                   parlourDetails: parlour,
//                   title: parlour['parlourName'] ?? '',
//                   imageUrl: base64Image ?? '',
//                   shopName: parlour['parlourName'] ?? '',
//                   shopAddress: parlour['location'] ?? 'No Address Available',
//                   contactNumber: parlour['phoneNumber'] ?? 'No Contact Available',
//                   description: parlour['description'] ?? 'No Description Available',
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     ),
//   );



//                     },
//                   ),
//                 ],
//                 SizedBox(height: 20),
//                 GridView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 0.8,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                   ),
//                   itemCount: _nearbyParlours.take(4).length,
//                   itemBuilder: (context, index) {
//                     final shop = _nearbyParlours[index];
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => BookingPage(
//                               imageUrl: shop['imageUrl']!,
//                               title: shop['shopName']!,
//                               shopName: shop['shopName']!,
//                               shopAddress: shop['address']!,
//                               contactNumber: shop['contactNumber']!,
//                               description: shop['description']!,
//                               parlourDetails: {},
//                             ),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.black38,
//                           borderRadius: BorderRadius.circular(15),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.white.withOpacity(0.3),
//                               spreadRadius: 1,
//                               blurRadius: 4,
//                               offset: Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Image.network(
//                                   shop['imageUrl']!,
//                                   width: double.infinity,
//                                   height: 120,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 shop['shopName']!,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 16,
//                                   color: Colors.white,
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 shop['description']!,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 14,
//                                   color: Colors.white,
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 shop['address']!,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 12,
//                                   color: Colors.white,
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 shop['contactNumber']!,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 12,
//                                   color: Colors.white,
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       ProfileScreen(), // Replace with your actual ProfilePage
//     ];

//     return Scaffold(
//       backgroundColor: const Color(0XFFCA7CD8),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: CurvedNavigationBar(
//         backgroundColor: Colors.black,
//         color: const Color(0XFFCA7CD8),
//         height: 60.0,
//         items: <Widget>[
//           Icon(Icons.home, size: 30, color: Colors.white),
//           Icon(Icons.person, size: 30, color: Colors.white),
//         ],
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         animationDuration: Duration(milliseconds: 300),
//         animationCurve: Curves.easeInOut,
//       ),
//     );
//   }
// }
