import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset(
          'assets/favlog.png',
          height: 120,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Sign Up',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Create an account to continue',
                      style:
                          TextStyle(color: Color.fromARGB(255, 110, 110, 110)),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                ],
              ),
              SizedBox(height: 20),

              // First Name
              _buildTextField(labelText: 'First Name'),

              SizedBox(height: 13),

              // Last Name
              _buildTextField(labelText: 'Last Name'),

              SizedBox(height: 13),

              // Country (Dropdown)
              _buildCountryDropdown(),

              SizedBox(height: 13),

              // Phone Number
              _buildTextField(
                  labelText: 'Phone Number', keyboardType: TextInputType.phone),

              SizedBox(height: 13),

              // Email Address
              _buildTextField(
                  labelText: 'Email Address',
                  keyboardType: TextInputType.emailAddress),

              SizedBox(height: 13),

              // Password
              _buildPasswordField(
                labelText: 'Password',
                showPassword: showPassword,
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              ),

              SizedBox(height: 13),

              // Confirm Password
              _buildPasswordField(
                labelText: 'Confirm Password',
                showPassword: showConfirmPassword,
                onPressed: () {
                  setState(() {
                    showConfirmPassword = !showConfirmPassword;
                  });
                },
              ),

              SizedBox(height: 20),

              // Privacy & Policy Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text.rich(
                  TextSpan(
                    text: 'By creating an account, you accept our ',
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: 'Privacy & Policy',
                        style: TextStyle(
                            color: Colors.red,
                            decoration: TextDecoration.underline),
                        // Link to Privacy & Policy
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to Privacy & Policy page
                          },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 20),

              // Sign Up Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 199, 18, 5),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  fixedSize: Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {
                  // Sign up functionality here
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),

              SizedBox(height: 25),

              // Already have an account? Login now
              GestureDetector(
                onTap: () {
                  // Navigate to LoginScreen
                  Navigator.pushNamed(context, '/login');
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: Color.fromARGB(255, 95, 95, 95)),
                    children: [
                      TextSpan(
                        text: 'Login now',
                        style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String labelText, TextInputType? keyboardType}) {
    return SizedBox(
      width: 300,
      height: 47,
      child: TextField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Color.fromARGB(255, 128, 127, 127)),
          filled: true,
          fillColor: Color.fromARGB(255, 248, 246, 246),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      {required String labelText,
      required bool showPassword,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: 300,
      height: 47,
      child: TextField(
        obscureText: !showPassword,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Color.fromARGB(255, 128, 127, 127)),
          filled: true,
          fillColor: Color.fromARGB(255, 248, 246, 246),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  Widget _buildCountryDropdown() {
    List<String> countries = ['Saudi Arabia', 'United Arab Emirates'];
    String selectedCountry = countries.first;

    return SizedBox(
      width: 300,
      child: DropdownButtonFormField<String>(
        value: selectedCountry,
        items: countries.map((String country) {
          return DropdownMenuItem<String>(
            value: country,
            child: Text(country),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedCountry = newValue!;
          });
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(255, 248, 246, 246),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
