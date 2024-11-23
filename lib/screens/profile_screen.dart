import 'package:alsaif_gallery/screens/account.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alsaif_gallery/screens/Edit_profile_screen.dart';
import 'package:alsaif_gallery/screens/favorites_screen.dart';
import 'package:alsaif_gallery/screens/login_screen.dart';

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
  String firstName = '';
  String lastName = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      final response = await http.get(
        Uri.parse('https://alsaifgallery.onrender.com/api/v1/user/getUserInfo'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          firstName = data['firstName'] ?? 'No first name';
          lastName = data['lastName'] ?? 'No last name';
          email = data['email'] ?? 'No email';
        });
      } else {
        debugPrint('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching user info: $e');
    }
  }

  void _toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset('assets/favlog.png', height: 110),
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
          Container(height: 1.0, color: Colors.grey[300]),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
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
                            color: const Color.fromARGB(255, 82, 81, 81),
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
                      style: TextStyle(fontSize: 10, color: Colors.grey),
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
                        'Settings  ',
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCircularButton(
                context,
                icon: Icons.shopping_cart,
                label: 'Orders',
                onTap: () {},
              ),
              _buildCircularButton(
                context,
                icon: Icons.assignment_return,
                label: 'Returns',
                onTap: () {},
              ),
              _buildCircularButton(
                context,
                icon: Icons.favorite,
                label: 'Favorites',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FavoritesScreen(
                              favoriteProducts: [],
                            )),
                  );
                },
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => logout(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.logout, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Logout',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
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
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
          ),
          onPressed: onTap,
          child: Icon(icon),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
