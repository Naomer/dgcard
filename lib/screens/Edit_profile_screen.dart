import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:country_picker/country_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String firstName = '';
  String lastName = '';
  String mobile = '';
  String selectedCountry = 'USA';
  Country? _selectedCountry;

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  final List<String> countries = ['USA', 'Canada', 'Germany', 'UK', 'India'];

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

// Fetch user information from the API
  Future<void> _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    print('Stored token: $token'); // Debug print for token

    if (token == null) {
      print('No token found');
      return;
    }

    final url =
        Uri.parse('https://alsaifgallery.onrender.com/api/v1/user/getUserInfo');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Parsed API Response: $data");

        // Check the exact keys in the response
        print("Response Keys: ${data.keys}");

        // Determine the correct key for user data
        dynamic userData = data['data'] ?? data['user'] ?? data;
        print("User Data: $userData");

        setState(() {
          // Populate text controllers with user info
          firstNameController.text =
              userData['firstName'] ?? userData['first_name'] ?? '';
          lastNameController.text =
              userData['lastName'] ?? userData['last_name'] ?? '';
          mobileController.text = userData['mobile'] ?? userData['phone'] ?? '';
          countryController.text = userData['country'] ?? '';

          // Update state variables
          firstName = firstNameController.text;
          lastName = lastNameController.text;
          mobile = mobileController.text;
          selectedCountry = userData['country'] ?? 'USA';

          print("Updated Controllers:");
          print("First Name: ${firstNameController.text}");
          print("Last Name: ${lastNameController.text}");
          print("Mobile: ${mobileController.text}");
        });
      } else {
        print('Failed to load user info: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> _changePassword() async {
    // Validate input fields
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _showErrorDialog('Please fill in all password fields');
      return;
    }

    // Check if new passwords match
    if (newPasswordController.text != confirmPasswordController.text) {
      _showErrorDialog('New passwords do not match');
      return;
    }

    // Retrieve token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _showErrorDialog('Authentication token not found. Please log in again.');
      return;
    }

    // API endpoint for changing password
    final url = Uri.parse(
        'https://alsaifgallery.onrender.com/api/v1/user/changePassword');

    try {
      // Prepare the request body
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'oldPassword': oldPasswordController.text,
          'newPassword': newPasswordController.text,
          'confirmPassword': confirmPasswordController.text,
        }),
      );

      // Parse the response
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Success scenario
        _showSuccessDialog('Password changed successfully');

        // Clear password fields after successful change
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else {
        // Error scenario
        final errorMessage =
            responseBody['message'] ?? 'Failed to change password';
        _showErrorDialog(errorMessage);
      }
    } catch (e) {
      // Network or unexpected error
      _showErrorDialog('An error occurred. Please try again.');
      print('Password change error: $e');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateProfile() async {
    // Validate input fields
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        mobileController.text.isEmpty) {
      _showErrorDialog('Please fill in all required fields');
      return;
    }

    // Retrieve token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _showErrorDialog('Authentication token not found. Please log in again.');
      return;
    }

    // API endpoint for updating profile
    final url = Uri.parse(
        'https://alsaifgallery.onrender.com/api/v1/user/updateProfile');

    try {
      // Prepare the request body
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'mobile': mobileController.text,
          'country': countryController.text,
        }),
      );

      // Parse the response
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Success scenario
        // Update SharedPreferences with new user data
        await prefs.setString('firstName', firstNameController.text);
        await prefs.setString('lastName', lastNameController.text);
        await prefs.setString('mobile', mobileController.text);
        await prefs.setString('country', countryController.text);

        _showSuccessDialog('Profile updated successfully');

        // Optionally refresh user info
        await _getUserInfo();
      } else {
        // Error scenario
        final errorMessage =
            responseBody['message'] ?? 'Failed to update profile';
        _showErrorDialog(errorMessage);
      }
    } catch (e) {
      // Network or unexpected error
      _showErrorDialog('An error occurred. Please try again.');
      print('Profile update error: $e');
    }
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
          selectedCountry = country.name;
          countryController.text = country.name;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Manage Account',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Change Password',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  _buildTextField(oldPasswordController, 'Old Password',
                      obscureText: true),
                  _buildTextField(newPasswordController, 'New Password',
                      obscureText: true),
                  _buildTextField(confirmPasswordController, 'Confirm Password',
                      obscureText: true),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.8, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Update Profile',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Expanded(
                        child:
                            _buildTextField(firstNameController, 'First Name'),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: _buildTextField(lastNameController, 'Last Name'),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  _buildTextField(mobileController, 'Mobile', isNumeric: true),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: countryController,
                    readOnly: true, // Make the field read-only
                    onTap: _showCountryPicker, // Open country picker on tap
                    decoration: InputDecoration(
                      labelText: 'Country',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a country';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.9, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: Text('Update Profile'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false, bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11.0),
            ),
            SizedBox(height: 4.0),
            TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType:
                  isNumeric ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                labelText: '',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
