import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloon_app/homescreen.dart';
import 'package:saloon_app/loginscreen.dart';
import 'package:saloon_app/RegisterPage.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a Stack to layer widgets, with the background image as the bottom-most widget
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background image setup
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/background img.jpg'), // Replace with your own image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Logo setup
          Positioned(
            top: 150.0, // Adjust the positioning as needed
            left: 123.0, // Adjust the positioning as needed
            child: Image.asset(
              'asset/salon_INFO-removebg-preview.png', // Replace with your own logo path
              width: 170, // Adjust the width as needed
              height:170, // Adjust the height as needed
            ),
          ),
          // Text setup
          Positioned(
            top: 50.0, // Adjust the vertical positioning as needed
            left: 0.0,
            right: 0.0,
            child: Center(
              child: Text(
                'SALON INFO',
                style:GoogleFonts.adamina(
                  textStyle: TextStyle(color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)
                )
              ),
            ),
          ),

          // Center widget containing your content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Optionally, you can include a welcome text
                SizedBox(height: 70.0), // Adding some space between text and buttons
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(250, 50),
                    backgroundColor: Colors.grey
                  ),
                  child: Text('LOGIN', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 20.0), // Adding some space between buttons
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                    print('Register button pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(250, 50),
                    backgroundColor:  Colors.grey,
                  ),
                  child: Text('REGISTER', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
