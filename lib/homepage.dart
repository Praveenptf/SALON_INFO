import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saloon_app/homescreen.dart'; 
import 'package:saloon_app/profile.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomeScreen(),
    ProfileScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex == 0) {
      // Show confirmation dialog
      final result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Exit'),
            content: Text('Do you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancel
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Exit
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      if (result == true) {
        // Exit the app
        SystemNavigator.pop();
        return false; // Return false to prevent any additional pop action
      }
      return false; // Return false to prevent any additional pop action
    } else {
      // Not on the home page, navigate to the home page
      setState(() {
        _currentIndex = 0; // Navigate to the home page
      });
      return false; // Prevent default back button behavior
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: BottomNavigationBar(
            selectedIconTheme: IconThemeData(color: Colors.black),
            unselectedIconTheme: IconThemeData(color: Colors.black),
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}


