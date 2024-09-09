import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/favlog.png',
          height: 120,
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // White background color for AppBar
        elevation: 0,
      ),
      body: Column(
        children: [
          // Shadowed line below the AppBar
          Container(
            height: 1.0,
            color: Colors.grey[300], // Line color
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Shadow color
                    offset: Offset(0, 2), // Shadow offset
                    blurRadius: 4, // Shadow blur radius
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Login',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Choose your login method',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 94, 92, 92)),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 57),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 137, // Custom width for the button
                      height: 107, // Custom height for the button
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle phone number login action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 187, 20, 8), // Fixed color
                          foregroundColor: Colors.white, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: const Color.fromARGB(255, 187, 20, 8),
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.smartphone_outlined,
                              color: Colors.white,
                              size: 37, // Increase icon size
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Phone Number',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 243, 242, 242),
                                fontSize: 12, // Adjust text size
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 28), // Increase the space between buttons
                    SizedBox(
                      width: 137, // Custom width for the button
                      height: 107, // Custom height for the button
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle email address login action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 187, 20, 8), // Fixed color
                          foregroundColor: Colors.white, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: const Color.fromARGB(255, 187, 20, 8),
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: Colors.white,
                              size: 37, // Increase icon size
                            ),
                            SizedBox(height: 15),
                            Text(
                              'E-Mail Address',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12, // Adjust text size
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'OR',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 94, 92, 92)),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35),
                SizedBox(
                  width: double.infinity, // Full width for the button
                  height: 48, // Custom height for the button
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 243, 61, 16), // Red background color
                      padding:
                          EdgeInsets.symmetric(vertical: 0), // No extra padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Straight edges
                      ),
                    ),
                    onPressed: () {
                      // Google login functionality here
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.white, // Set Google icon color to white
                      size: 24, // Increase icon size
                    ),
                    label: Text(
                      'LOGIN WITH GOOGLE',
                      style: TextStyle(
                        color: Colors.white, // Set text color to white
                        fontSize: 16,
                        fontWeight: FontWeight.normal, // Unbolded text
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    // Navigate to the registration screen
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 94, 92, 92)),
                      children: [
                        TextSpan(
                          text: 'REGISTER NOW',
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ), // Add login options here
              ],
            ),
          ),
        ],
      ),
    );
  }
}
