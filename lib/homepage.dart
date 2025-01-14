import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:saloon_app/Booking%20details.dart';
import 'package:saloon_app/Location.dart';
import 'package:saloon_app/parlours.dart';
import 'package:saloon_app/slider.dart';
import 'package:saloon_app/profile.dart';

class HomePage extends StatefulWidget {
  final List<dynamic> initialNearbyParlours;

  HomePage({Key? key, this.initialNearbyParlours = const []}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  List<dynamic> _nearbyParlours = [];
  bool _isLoading = true;
  bool _isAppBarVisible = true;
  TextEditingController searchController = TextEditingController();
  late ScrollController _scrollController;
  final FocusNode _searchFocusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _nearbyParlours = widget.initialNearbyParlours;
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        searchController.clear();
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isAppBarVisible) setState(() => _isAppBarVisible = false);
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isAppBarVisible) setState(() => _isAppBarVisible = true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onLocationSelected(LatLng location, List<dynamic> nearbyParlours) {
    setState(() {
      _nearbyParlours = nearbyParlours;
      _isLoading = false;
    });
  }

  void _filterParlours(String query) {
  if (query.isEmpty) {
    // If the search query is empty, reset to the original list
    _nearbyParlours = widget.initialNearbyParlours;
  } else {
    // Filter the parlours based on the search query
    _nearbyParlours = widget.initialNearbyParlours.where((parlour) {
      String parlourName = parlour['parlourName']?.toLowerCase() ?? '';
      return parlourName.contains(query.toLowerCase());
    }).toList();
  }
}



  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Scaffold(
        backgroundColor: Colors.white,
        appBar: _isAppBarVisible
            ? AppBar(
                elevation: 0,
                toolbarHeight: 125,
                backgroundColor: Colors.white,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.deepPurple.shade50,
                        Colors.white,
                      ],
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Salon Info",
                          style: GoogleFonts.adamina(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade800,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple.shade400,
                                Colors.deepPurple.shade800,
                              ],
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.location_on, color: Colors.white),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Mappage(
                                    onLocationSelected: _onLocationSelected,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
  controller: searchController,
  onChanged: (value) {
    setState(() {
      // Call the method to filter parlours based on the search query
      _filterParlours(value);
    });
  },
  decoration: InputDecoration(
    hintText: 'Search...',
    hintStyle: TextStyle(color: Colors.grey.shade400),
    prefixIcon: Icon(
      Icons.search,
      color: Colors.deepPurple.shade300,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: Colors.white,
  ),
),
                    ),
                  ],
                ),
                automaticallyImplyLeading: false,
              )
            : null,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 16),
                  ImageCarousel(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to Salon Info',
                          style: GoogleFonts.adamina(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Explore Our Services and Book your Appointment Easily',
                          style: GoogleFonts.adamina(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nearby Services',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade800,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Parlours(
                                  parlourShops: _nearbyParlours,
                                  serviceFilter: searchController.text,
                                ),
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
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  if (_isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.deepPurple.shade400,
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _nearbyParlours.length,
                     
itemBuilder: (context, index) {
  final parlour = _nearbyParlours[index];
  String? imageUrl = parlour['image'];

  ImageProvider imageProvider;

  print('Image URL: $imageUrl'); // Debugging

  if (imageUrl == null || imageUrl.isEmpty) {
    imageProvider = AssetImage('asset/saloon_3-removebg-preview.png');
  } else if (imageUrl.startsWith('data:image/')) {
    try {
      final base64Image = imageUrl.split(',').last; // Get the base64 part
      final decodedImage = base64Decode(base64Image); // Decode the base64 string
      imageProvider = MemoryImage(decodedImage); // Create MemoryImage
    } catch (e) {
      print('Error decoding base64 image: $e');
      imageProvider = AssetImage('asset/saloon_3-removebg-preview.png');
    }
  } else {
    try {
      Uri.parse(imageUrl); // Validate the URL
      imageProvider = NetworkImage(imageUrl); // Use NetworkImage for URLs
    } catch (e) {
      print('Invalid URL: $e');
      imageProvider = AssetImage('asset/saloon_3-removebg-preview.png');
    }
  }

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingPage(
                parlourDetails: parlour,
                title: parlour['parlourName'] ?? '',
                imageUrl: imageUrl ?? '',
                shopName: parlour['parlourName'] ?? '',
                shopAddress: parlour['location'] ?? 'No Address Available',
                contactNumber: parlour['phoneNumber'] ?? 'No Contact Available',
                description: parlour['description'] ?? 'No Description Available',
                id: parlour['id'] ?? 'No id',
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Container(
                height: 120,
                width: double.infinity,
                child: FadeInImage(
                  placeholder: AssetImage('asset/saloon_3-removebg-preview.png'),
                  image: imageProvider,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'asset/saloon_3-removebg-preview.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parlour['parlourName'] ?? 'Unknown Parlour',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox 
                  (height: 4),
                  Text(
                    parlour['location'] ?? 'No Location Available',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 4),
                      Text(
                        parlour['ratings']?.toString() ?? 'No Ratings',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      ProfileScreen(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade400,
              Colors.deepPurple.shade800,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}