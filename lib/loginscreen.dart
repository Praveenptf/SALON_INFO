import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:saloon_app/RegisterPage.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:saloon_app/homepage.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Password visibility state
  bool _loginError = false; // Error state for login credentials

  String? _usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://192.168.1.27:8086/user/UserLogin'), 
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'phoneNumber': _phoneNumberController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode <300 ) {
        // If the server returns an OK response, navigate to the HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // If the server did not return an OK response, show an error message
        setState(() {
          _loginError = true; // Set login error state
        });
      }
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/background img.jpg'), // Updated image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 100, // Adjust the top position as needed
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Text(
                    'SALON INFO',
                    style: GoogleFonts.adamina(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 30),
                  Image.asset(
                    'asset/saloon_3-removebg-preview.png', // Path to the logo image
                    height: 180, // Adjust the height as needed
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 300), // Adjust the height to give space below the title
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 130),
                        TextFormField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0), // Curved border
                            ),
                            errorStyle: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              height: 1.2, // Adjust height to ensure error message fits well
                            ),
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            filled: true,
                            fillColor: Colors.white, // Optional: to set background color of the text field
                          ),
                          validator: _usernameValidator,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible, // Use the boolean variable here
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0), // Curved border
                            ),
                            errorStyle: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              height: 1.2, // Adjust height to ensure error message fits well
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            filled: true,
                            fillColor: Colors.white, // Optional: to set background color of the text field
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: _passwordValidator,
                        ),
                        if (_loginError) ...[ // Display error message if login fails
                          SizedBox(height: 10),
                          Text(
                            'Invalid credentials. Please try again.',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: _login, // Call the login function
                          child: Text(
                            'LOGIN',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 130),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to Sign Up page
                                // Assuming you have a SignUpPage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignupPage()),
                                );
                              },
                              child: Text(
                                'Sign up',
                                style: TextStyle(color: Colors.white),
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
        ],
      ),
    );
  }
}
