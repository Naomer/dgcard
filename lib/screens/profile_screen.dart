import 'package:alsaif_gallery/screens/Edit_profile_screen.dart';
import 'package:alsaif_gallery/screens/account.dart';
import 'package:alsaif_gallery/screens/favorites_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data!) {
          return ProfileScreen();
        } else {
          return Account();
        }
      },
    );
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;
  bool isNotificationsAllowed = false;
  String firstName = '';
  String lastName = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName') ?? 'Guest';
      lastName = prefs.getString('lastName') ?? '';
      email = prefs.getString('email') ?? 'Not set';
    });
  }

  void _toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  Future<void> logout(BuildContext context) async {
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true), child: Text("Logout")),
        ],
      ),
    );

    if (confirm) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Account()),
        (route) => false,
      );
    }
  }

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
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleDarkMode,
          ),
        ],
      ),
      body: Column(
        children: [
          // Horizontal divider below AppBar
          Container(
            height: 1,
            color: Colors.grey[300],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Welcome, ',
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 82, 81, 81),
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '$firstName $lastName',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              email,
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfileScreen()),
                            );
                          },
                          child: Row(
                            children: const [
                              Text(
                                'Settings ',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 177, 16, 16),
                                  fontSize: 15,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Color.fromARGB(255, 165, 35, 25),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCircularButton(
                          context,
                          icon: Icons.shopping_cart_outlined,
                          label: 'Orders',
                          onTap: () {},
                        ),
                        _buildCircularButton(
                          context,
                          icon: Icons.assignment_return_outlined,
                          label: 'Returns',
                          onTap: () {},
                        ),
                        _buildCircularButton(
                          context,
                          icon: Icons.favorite_border,
                          label: 'Wishlist',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FavoritesScreen(
                                        token: 'token',
                                      )),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                        color: const Color.fromARGB(255, 250, 249, 249),
                        child: Column(children: [
                          _buildListTile(
                            title: 'Saved Address',
                            onTap: () {},
                            leading: Icon(Icons
                                .map), // Add the map icon for this specific item
                          ),
                        ])),
                    SizedBox(height: 20),
                    Container(
                      color: const Color.fromARGB(255, 250, 249, 249),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              'Allow Notifications',
                              style: TextStyle(fontSize: 13),
                            ),
                            trailing: Switch(
                              value: isNotificationsAllowed,
                              onChanged: (value) {
                                setState(() {
                                  isNotificationsAllowed = value;
                                });
                              },
                            ),
                          ),
                          _buildListTile(
                            title: 'Contact Us',
                            onTap: () {},
                          ),
                          _buildListTile(
                            title: 'Our Story',
                            onTap: () {},
                          ),
                          _buildListTile(
                            title: 'Loyalty Points Policy',
                            onTap: () {},
                          ),
                          _buildListTile(
                            title: 'Privacy Policy',
                            onTap: () {},
                          ),
                          _buildListTile(
                            title: 'Payment Method',
                            onTap: () {},
                          ),
                          _buildListTile(
                            title: 'Feedback',
                            onTap: () {},
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.facebook, color: Colors.black),
                                onPressed: () {},
                              ),
                              SizedBox(width: 46), // Add spacing between icons
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.twitter,
                                    color: Colors.black),
                                onPressed: () {},
                              ),
                              SizedBox(width: 46), // Add spacing between icons
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.instagram,
                                    color:
                                        const Color.fromARGB(255, 77, 75, 75)),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          GestureDetector(
                            onTap: () => logout(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.logout,
                                    color: Color.fromARGB(255, 173, 30, 20)),
                                SizedBox(width: 5),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 177, 38, 28),
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 25),
                          Text(
                            '• Shipping and delivery information     '
                            '• How to buy\n'
                            '\n'
                            '• Terms and conditions                          '
                            '• FAQs\n'
                            '\n'
                            '• Return policy'
                            '• Warranty',
                            style: TextStyle(fontSize: 11),
                          ),
                          const SizedBox(height: 20),
                          const Center(
                            child: Text(
                              '\nDigital Card © 2024 • All rights reserved.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(
              side: BorderSide(
                  color: Color.fromARGB(255, 168, 128, 128),
                  width: 2), // Red outline
            ),
            padding: const EdgeInsets.all(20),
            backgroundColor: Colors.white, // White button
          ),
          onPressed: onTap,
          child: Icon(
            icon,
            color: Color.fromARGB(255, 168, 128, 128), // Gray icon
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12), // Reduced font size
        ),
      ],
    );
  }

  Widget _buildListTile(
      {required String title, required VoidCallback onTap, Widget? leading}) {
    return ListTile(
      leading:
          leading, // This will conditionally display the leading widget (icon)
      title: Text(
        title,
        style: TextStyle(fontSize: 13),
      ),
      trailing: Icon(Icons.arrow_forward_ios), // Keep the arrow icon for others
      onTap: onTap,
    );
  }
}
