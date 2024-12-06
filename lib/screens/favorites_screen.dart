import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _isLoggedIn = false;
  bool _isCheckingLogin = true;
  List<Map<String, dynamic>> _favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userToken = prefs.getString('userToken') ?? '';

    setState(() {
      _isLoggedIn = isLoggedIn;
      _isCheckingLogin = false;
    });

    if (_isLoggedIn && userToken.isNotEmpty) {
      // If logged in, fetch the favorite products
      final userId = prefs.getString('userId') ??
          ''; // Retrieve user ID from SharedPreferences (if stored)
      _fetchFavoriteProducts(userToken, userId); // Pass userToken and userId
    }
  }

  Future<void> _fetchFavoriteProducts(String token, String userId) async {
    final url = Uri.parse(
        'https://alsaifgallery.onrender.com/api/v1/user/getFavoriteProducts?userId=$userId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Send the token in the header
      },
    );

    if (response.statusCode == 200) {
      // Log the response body to see the full response from the API
      print('Response body: ${response.body}');

      // If the request is successful, parse the JSON data
      final data = json.decode(response.body);

      // Check if 'data' exists and is a list
      if (data['data'] != null && data['data'] is List) {
        setState(() {
          _favoriteProducts = List<Map<String, dynamic>>.from(data['data']);
        });
      } else {
        // Handle unexpected response format
        print('Favorite products data is not in expected format.');
      }
    } else {
      // Handle errors or unsuccessful request
      print('Failed to load favorite products: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingLogin) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isLoggedIn) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Image.asset(
            'assets/favlog.png',
            height: 120,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              height: 1.0,
              color: Colors.grey[300],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/favno.webp',
                    height: 240,
                    width: 800,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Oops! Empty.\nTap ❤️ to add an item to your wishlist.',
                    style: TextStyle(fontSize: 11, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 185, 41, 30),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 90, vertical: 13),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text(
                      'Continue Shopping',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // For logged-in users, display the list of favorite products
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/favlog.png',
          height: 120,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: 1.0,
            color: Colors.grey[300],
          ),
          Expanded(
            child: _favoriteProducts.isEmpty
                ? const Center(
                    child: Text(
                      'No favorite products to display.',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  )
                : ListView.builder(
                    itemCount: _favoriteProducts.length,
                    itemBuilder: (context, index) {
                      final product = _favoriteProducts[index];
                      return ListTile(
                        title: Text(product['name'] ?? 'No name'),
                        subtitle:
                            Text(product['description'] ?? 'No description'),
                        leading: Image.network(product['image'] ?? ''),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
