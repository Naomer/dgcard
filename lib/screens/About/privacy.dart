import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Privacy & Policy',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Title text color
          ),
        ),
        backgroundColor: Colors.white, // AppBar background color
        elevation: 0, // Remove shadow under the AppBar
        centerTitle: true, // Centers the title
      ),
      body: Column(
        children: [
          // Horizontal divider between AppBar and body
          Divider(
            color: Colors.grey, // Color of the divider
            thickness: 1, // Thickness of the divider
            indent: 0.0, // Left indent
            endIndent: 0.0, // Right indent
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Effective Date: September 2024\n\n'
                    'This Privacy Policy explains how we collect, use, and protect your personal data when you use our services. By using our app, you agree to the terms of this policy.\n\n'
                    '1. Information Collection\n'
                    'We collect personal information that you provide when you use our services, such as your name, email address, phone number, and payment details.\n\n'
                    '2. Data Usage\n'
                    'Your information may be used to improve the app, process payments, and communicate with you about services, promotions, and updates.\n\n'
                    '3. Data Protection\n'
                    'We take appropriate security measures to protect your personal data from unauthorized access, alteration, or destruction.\n\n'
                    '4. Third-Party Services\n'
                    'We may share your information with third-party services to facilitate payment processing and provide necessary app functionality.\n\n'
                    '5. Your Rights\n'
                    'You have the right to access, update, or delete your personal information at any time. To do so, please contact us at support@digitalcard.com.\n\n'
                    '6. Changes to This Policy\n'
                    'We may update this Privacy Policy from time to time. Any changes will be posted on this page with the updated effective date.\n\n'
                    'By using our app, you consent to the collection and use of your information as described in this Privacy Policy.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: const Color.fromARGB(255, 122, 122, 122),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the privacy policy page
                    },
                    child: Text('Back'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Customize the button color
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
