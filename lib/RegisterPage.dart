import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:saloon_app/homepage.dart';
import 'dart:convert';
import 'package:saloon_app/loginscreen.dart';
import 'package:email_validator/email_validator.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/background img.jpg'), 
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RegistrationForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String _firstName = '';
  String _mobileNumber = '';
  String _email = '';
  String _password = '';
  //String _confirmPassword = '';

  // State to manage password visibility
  bool _isPasswordVisible = false;
  //bool _isConfirmPasswordVisible = false;

  
  final String _backendUrl = 'http://192.168.1.27:8086/user/UserReg'; 

  
  Future<void> _registerUser() async {
    
    final user = {
      'fullName': _firstName,
      'phoneNumber': _mobileNumber,
      'email': _email,
      'password': _password,
      'gender':"",
    };

    try {
      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user),
      );

      // Check if the request was successful
      if (response.statusCode >= 200 && response.statusCode <300  ) {
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${response.body}')),
        );
      }
    } catch (error) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Logo at the top
            Image.asset(
              'asset/saloon_3-removebg-preview.png', 
              height: 150,
              width: 150,
            ),
            SizedBox(height: 32),

            // Form fields
            _buildTextField(
              label: 'Full Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                if (value.length < 4) {
                  return 'Username must be at least 4 characters long';
                }
                return null;
              },
              onSaved: (value) {
                _firstName = value!;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              label: 'Mobile Number',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your mobile number';
                }
                if (value.length < 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'Please enter a valid mobile number';
                }
                return null;
              },
              onSaved: (value) {
                _mobileNumber = value!;
              },
            ),
            SizedBox(height: 16.0),
            _buildTextField(
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                if (!EmailValidator.validate(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              onSaved: (value) {
                _email = value!;
              },
            ),
            SizedBox(height: 16.0),
            _buildTextField(
              label: 'Password',
              obscureText: !_isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
              onSaved: (value) {
                _password = value!;
              },
            ),
            // SizedBox(height: 16.0),
            // _buildTextField(
            //   label: 'Confirm Password',
            //   obscureText: !_isConfirmPasswordVisible,
            //   suffixIcon: IconButton(
            //     icon: Icon(
            //       _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
            //       color: Colors.black,
            //     ),
            //     onPressed: () {
            //       setState(() {
            //         _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            //       });
            //     },
            //   ),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please confirm your password';
            //     }
            //     if (value != _password) {
            //       return 'Passwords do not match';
            //     }
            //     return null;
            //   },
            //   onSaved: (value) {
            //     _confirmPassword = value!;
            //   },
            // ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _registerUser(); 
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                minimumSize: Size(150, 50),
              ),
              child: Text('REGISTER', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Already have an account ?',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: Colors.black),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(30.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
