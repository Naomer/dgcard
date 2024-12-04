import 'package:alsaif_gallery/provider/AuthProvider.dart';
import 'package:alsaif_gallery/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data!) {
          return FutureBuilder<String?>(
            future: getToken(),
            builder: (context, tokenSnapshot) {
              if (tokenSnapshot.hasData && tokenSnapshot.data != null) {
                return FavoritesScreen(token: tokenSnapshot.data!);
              } else {
                return const Center(
                    child: Text("Error: Unable to fetch token"));
              }
            },
          );
        } else {
          return const LoginScreen(); // Redirect to login screen
        }
      },
    );
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}

Future<Map<String, dynamic>> getAuthData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final token = prefs.getString('token');
  print("isLoggedIn: $isLoggedIn, token: $token"); // Debug log
  return {'isLoggedIn': isLoggedIn, 'token': token};
}

class FavoritesScreen extends StatefulWidget {
  final String token;

  const FavoritesScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favoriteProducts = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> _fetchFavoriteProducts(String token) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://alsaifgallery.onrender.com/api/v1/user/getFavoriteProducts'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print("HTTP Status Code: ${response.statusCode}");
      print("HTTP Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final products = data['products'];
        if (products != null && products is List) {
          setState(() {
            favoriteProducts = List<Map<String, dynamic>>.from(products);
          });
        } else {
          setState(() {
            errorMessage = 'No products found.';
          });
        }
      }
    } catch (error) {
      print("Error during fetch: $error");
      setState(() {
        errorMessage = 'Error: ${error.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchFavoriteProducts(widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/favlog.png',
          height: 120,
        ),
        centerTitle: true,
      ),
      body: widget.token == null
          ? _buildLoggedOutView()
          : isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Center(child: Text(errorMessage!))
                  : _buildFavoriteProductsView(),
    );
  }

  Widget _buildLoggedOutView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/favo.png',
            height: 240,
            width: 800,
          ),
          const SizedBox(height: 4),
          const Text(
            'Choose your favorite products to buy later.',
            style: TextStyle(fontSize: 13, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 167, 15, 4),
              padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 13),
              textStyle: const TextStyle(fontSize: 16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              'Start Shopping',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteProductsView() {
    print("Favorite products count: ${favoriteProducts.length}");
    if (favoriteProducts.isEmpty) {
      return const Center(child: Text('No favorite products found.'));
    }

    return ListView.builder(
      itemCount: favoriteProducts.length,
      itemBuilder: (context, index) {
        final product = favoriteProducts[index];
        return ListTile(
          leading: Image.network(
            product['imageUrl'] ?? '',
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
          title: Text(product['name'] ?? 'Unknown Product'),
          subtitle: Text(product['price'] != null
              ? '\$${product['price']}'
              : 'Price unavailable'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                favoriteProducts.removeAt(index);
              });
            },
          ),
        );
      },
    );
  }
}
