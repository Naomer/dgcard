import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String firstName = '';
  String lastName = '';
  String mobile = '';
  String selectedCountry = 'USA';

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
    final url =
        Uri.parse('https://alsaifgallery.onrender.com/api/v1/user/getUserInfo');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Debug: Check the structure of the response data
        print("API Response: $data");

        // Make sure the keys exist in the response
        if (data.containsKey('firstName') &&
            data.containsKey('lastName') &&
            data.containsKey('mobile')) {
          setState(() {
            firstName = data['firstName'];
            lastName = data['lastName'];
            mobile = data['mobile'];
            firstNameController.text = firstName;
            lastNameController.text = lastName;
            mobileController.text = mobile;
          });
        } else {
          print('Missing expected keys in response: $data');
        }
      } else {
        print('Failed to load user info, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> changePassword() async {
    if (newPasswordController.text == confirmPasswordController.text) {
      final url = Uri.parse(
          'http://alsaifgallery.onrender.com/api/v1/user/changePassword');
      final body = jsonEncode({
        'oldPassword': oldPasswordController.text,
        'newPassword': newPasswordController.text,
      });

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        if (response.statusCode == 200) {
          print('Password changed successfully');
        } else {
          print('Failed to change password');
        }
      } catch (e) {
        print('Error changing password: $e');
      }
    } else {
      print('New password and confirm password do not match');
    }
  }

  Future<void> updateProfile() async {
    final url = Uri.parse(
        'http://alsaifgallery.onrender.com/api/v1/user/updateProfile/6710faf54f70141c97cf7dd8');
    final body = jsonEncode({
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'mobile': mobileController.text,
      'country': selectedCountry,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully');
      } else {
        print('Failed to update profile');
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
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
                      onPressed: changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.9, 50),
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
                  _buildCountryDropdown(),
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

  Widget _buildCountryDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Country',
              style: TextStyle(fontSize: 11.0),
            ),
            SizedBox(height: 4.0),
            DropdownButtonFormField<String>(
              value: selectedCountry,
              onChanged: (value) {
                setState(() {
                  selectedCountry = value!;
                });
              },
              items: countries.map((country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
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
