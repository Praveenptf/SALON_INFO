import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloon_app/RegisterPage.dart';
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
      return 'Please enter your username';
    }
    if (value.length < 4) {
      return 'Username must be at least 4 characters long';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  // Only validate that the password is at least 8 characters long
  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
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
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // If both fields pass validation, navigate to the HomePage
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            }
                          },
                          child: Text(
                            'LOGIN',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 130),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupPage()),
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
