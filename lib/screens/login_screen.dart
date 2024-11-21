import 'package:alsaif_gallery/widgets/MainScreen.dart';
import 'package:alsaif_gallery/api/api_service.dart';
import 'package:alsaif_gallery/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  final bool showSkipButton;

  const LoginScreen({super.key, this.showSkipButton = false});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = false;
  bool showLoginForm = true;
  String selectedCountry = 'Saudi Arabia';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset('assets/favlog.png', height: 120),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (widget.showSkipButton)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
              child: Text('Skip',
                  style: TextStyle(color: Colors.red, fontSize: 16)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
              SizedBox(height: 50),
              Text(
                showLoginForm ? 'Login' : 'Register',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              showLoginForm ? _buildLoginForm() : _buildRegistrationForm(),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showLoginForm = !showLoginForm;
                  });
                },
                child: RichText(
                  text: TextSpan(
                    text: showLoginForm
                        ? 'Don\'t have an account? '
                        : 'Already have an account? ',
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: showLoginForm ? 'Register now' : 'Login',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
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

  Widget _buildLoginForm() {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'E-Mail Address',
            labelStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Color.fromARGB(255, 248, 246, 246),
            border: InputBorder.none,
          ),
        ),
        SizedBox(height: 15),
        _buildPasswordField(
          labelText: 'Password',
          showPassword: showPassword,
          onPressed: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
        ),
        SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: _forgotPassword,
            child: Text(
              'Forgot Password?',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 199, 18, 5),
            padding: EdgeInsets.symmetric(vertical: 12),
            fixedSize: Size(300, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          onPressed: () async {
            await _login();
          },
          child: Text('LOGIN',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController emailResetController = TextEditingController();
        return AlertDialog(
          title: Text('Forgot Password'),
          content: TextField(
            controller: emailResetController,
            decoration: InputDecoration(labelText: 'Enter your email'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final String email = emailResetController.text;
                if (email.isNotEmpty) {
                  await _sendPasswordReset(email);
                }
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendPasswordReset(String email) async {
    final String url =
        'http://alsaifgallery.onrender.com/api/v1/user/sendForgetPasswordCode';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        _showErrorDialog('Password reset link sent. Check your email.');
      } else {
        _showErrorDialog('Failed to send reset link. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred. Please try again later.');
    }
  }

  Future<void> _login() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("Please fill out all fields.");
      return;
    }

    try {
      final response = await apiService.post('/api/v1/user/signin',
          body: jsonEncode({'email': email, 'password': password}));

      if (response.statusCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ),
          (route) => false,
        );
      } else {
        _showErrorDialog('Login failed. Please check your credentials.');
      }
    } catch (e) {
      _showErrorDialog('Network error: ${e.toString()}');
    }
  }

  Future<void> _register() async {
    final String firstName = firstNameController.text;
    final String lastName = lastNameController.text;
    final String phoneNumber = phoneController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String userName = userNameController.text;
    final String customerType = "web";

    if ([firstName, lastName, phoneNumber, email, password, userName]
        .contains('')) {
      _showErrorDialog("Please fill out all fields.");
      return;
    }
    if (selectedCountry.isEmpty) {
      _showErrorDialog("Please select a country.");
      return;
    }

    final Map<String, dynamic> registrationData = {
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'mobile': phoneNumber,
      'password': password,
      'customerType': customerType,
      'country': selectedCountry,
    };

    try {
      final response = await apiService.post(
        '/api/v1/user/register',
        body: jsonEncode(registrationData),
      );

      print("Registration Response Status: ${response.statusCode}");
      print("Registration Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        } else {
          _showErrorDialog(
              responseBody['message'] ?? 'Registration failed. Try again.');
        }
      } else {
        final responseBody = jsonDecode(response.body);
        _showErrorDialog(
            responseBody['message'] ?? 'Registration failed. Try again.');
      }
    } catch (e) {
      // Handle network or other errors
      _showErrorDialog('Network error: ${e.toString()}');
    }
  }

  Widget _buildPasswordField({
    required String labelText,
    required bool showPassword,
    required VoidCallback onPressed,
  }) {
    return TextField(
      controller: labelText == 'Password'
          ? passwordController
          : TextEditingController(),
      obscureText: !showPassword,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Color.fromARGB(255, 248, 246, 246),
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: onPressed,
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRegistrationForm() {
    return Column(
      children: [
        TextField(
          controller: firstNameController,
          decoration: InputDecoration(
            labelText: 'First Name',
            labelStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Color.fromARGB(255, 248, 246, 246),
            border: InputBorder.none,
          ),
        ),
        SizedBox(height: 15),
        TextField(
          controller: lastNameController,
          decoration: InputDecoration(
            labelText: 'Last Name',
            labelStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Color.fromARGB(255, 248, 246, 246),
            border: InputBorder.none,
          ),
        ),
        SizedBox(height: 15),
        TextField(
          controller: phoneController,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            labelStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Color.fromARGB(255, 248, 246, 246),
            border: InputBorder.none,
          ),
        ),
        SizedBox(height: 15),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'E-Mail Address',
            labelStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Color.fromARGB(255, 248, 246, 246),
            border: InputBorder.none,
          ),
        ),
        SizedBox(height: 15),
        _buildPasswordField(
          labelText: 'Password',
          showPassword: showPassword,
          onPressed: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
        ),
        SizedBox(height: 15),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 199, 18, 5),
            padding: EdgeInsets.symmetric(vertical: 12),
            fixedSize: Size(300, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          onPressed: () async {
            await _register();
          },
          child: Text('REGISTER',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }
}