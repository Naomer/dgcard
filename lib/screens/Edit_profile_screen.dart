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
  String email = '';
  bool isSettingsVisible = false;

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
      'country': countryController.text,
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
        title: Text('Profile', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (firstName.isNotEmpty && lastName.isNotEmpty) ...[
              Text(
                'Welcome, $firstName $lastName',
                style: TextStyle(fontSize: 20),
              ),
              Text(email),
            ],
            GestureDetector(
              onTap: () {
                setState(() {
                  isSettingsVisible = !isSettingsVisible;
                });
              },
              child: Row(
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                  Icon(isSettingsVisible
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down),
                ],
              ),
            ),
            if (isSettingsVisible)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: oldPasswordController,
                      decoration: InputDecoration(labelText: 'Old Password'),
                      obscureText: true,
                    ),
                    TextField(
                      controller: newPasswordController,
                      decoration: InputDecoration(labelText: 'New Password'),
                      obscureText: true,
                    ),
                    TextField(
                      controller: confirmPasswordController,
                      decoration:
                          InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                    ),
                    ElevatedButton(
                      onPressed: changePassword,
                      child: Text('Change Password'),
                    ),
                    TextField(
                      controller: firstNameController,
                      decoration: InputDecoration(labelText: 'First Name'),
                    ),
                    TextField(
                      controller: lastNameController,
                      decoration: InputDecoration(labelText: 'Last Name'),
                    ),
                    TextField(
                      controller: mobileController,
                      decoration: InputDecoration(labelText: 'Mobile'),
                    ),
                    TextField(
                      controller: countryController,
                      decoration: InputDecoration(labelText: 'Country'),
                    ),
                    ElevatedButton(
                      onPressed: updateProfile,
                      child: Text('Update Profile'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
