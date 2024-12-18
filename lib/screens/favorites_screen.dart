import 'dart:io' show HttpClient;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _isLoggedIn = false;
  bool _isCheckingLogin = true;
  bool _isLoading = true;
  List<Map<String, dynamic>> _favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check login status and fetch token
  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Comprehensive logging of SharedPreferences
      print('🔍 SharedPreferences Debugging:');
      print('All Keys: ${prefs.getKeys()}');

      // Check for token and login status
      final token = prefs.getString('token');
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      print('🔑 Token: ${token ?? "NO TOKEN"}');
      print('🔒 Is Logged In: $isLoggedIn');
      print('🔑 Token Length: ${token?.length ?? 0}');

      setState(() {
        _isLoggedIn = token != null && token.isNotEmpty;
        _isCheckingLogin = false;
        _isLoading = _isLoggedIn;
      });

      if (_isLoggedIn && token != null) {
        await _fetchFavoriteProducts(token);
      } else {
        print('⚠️ Not logged in or token is empty');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error in _checkLoginStatus: $e');
      setState(() {
        _isLoggedIn = false;
        _isCheckingLogin = false;
        _isLoading = false;
      });
    }
  }

  // Fetch favorite products from the API
  Future<void> _fetchFavoriteProducts(String token) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://alsaifgallery.onrender.com/api/v1/user/getFavoriteProducts');

    try {
      print('🚀 Fetching Favorites with Token: ${token.substring(0, 10)}...');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          print('🧩 Decoded Data: $data');

          // Extract favorite products from the nested structure
          List<dynamic> favoriteProducts = [];
          if (data is Map &&
              data['status'] == true &&
              data['user'] != null &&
              data['user']['favoriteProducts'] is List) {
            favoriteProducts = data['user']['favoriteProducts'];
          }

          // Process and transform favorite products
          setState(() {
            _favoriteProducts =
                favoriteProducts.map<Map<String, dynamic>>((item) {
              // Prioritize signed URLs for image
              String? imageUrl;
              // Check if signedUrls exist and are not empty
              if (item['signedUrls'] != null &&
                  item['signedUrls'] is List &&
                  (item['signedUrls'] as List).isNotEmpty) {
                imageUrl = item['signedUrls'][0];
                print('🖼️ Using Signed URL: $imageUrl');
              }
              // Fallback to imageIds if no signed URLs
              else if (item['imageIds'] != null &&
                  item['imageIds'] is List &&
                  item['imageIds'].isNotEmpty) {
                dynamic firstImageId = item['imageIds'][0];
                if (firstImageId is Map && firstImageId.containsKey('_id')) {
                  imageUrl =
                      'https://alsaifgallery.onrender.com/api/v1/product/image/${firstImageId['_id']}';
                } else if (firstImageId is String) {
                  imageUrl =
                      'https://alsaifgallery.onrender.com/api/v1/product/image/$firstImageId';
                }
              }

              print('🖼️ Final Image URL: $imageUrl');

              return {
                'id': item['_id'] ?? '',
                'name': item['name'] ?? 'Unknown Product',
                'description': item['description'] ?? '',
                'price': item['price'] ?? '0',
                'image': imageUrl,
                'category': item['category']?['categoryName'] ?? 'No Category',
                'additionalInfo': item['additionalInformation'] ?? {}
              };
            }).toList();

            print('✅ Parsed Favorite Products: $_favoriteProducts');
            _isLoading = false;
          });
        } catch (parseError) {
          print('❌ Parsing Error: $parseError');
          setState(() {
            _favoriteProducts = [];
            _isLoading = false;
          });
        }
      } else {
        print('❌ API Error: ${response.statusCode}');
        print('❌ Error Body: ${response.body}');
        setState(() {
          _favoriteProducts = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Network Error: $e');
      setState(() {
        _favoriteProducts = [];
        _isLoading = false;
      });
    }
  }

  // Method to remove a favorite product
  Future<void> _removeFavoriteProduct(String productId) async {
    // Get the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to remove favorites')),
      );
      return;
    }

    // Alternative removal endpoint
    final url = Uri.parse(
        'https://alsaifgallery.onrender.com/api/v1/user/removeFavoriteProduct');

    try {
      print('🗑️ Attempting to Remove Favorite Product: $productId');
      print('🔑 Using Token: ${token.substring(0, 10)}...');

      // Detailed logging of request
      print('🌐 Removal Request Details:');
      print('   URL: $url');
      print('   Product ID: $productId');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'productId': productId,
        }),
      );

      print('🗑️ Remove Favorite Response Status: ${response.statusCode}');
      print('🗑️ Remove Favorite Response Body: ${response.body}');

      // Parse the response
      final responseBody = json.decode(response.body);

      print('🔍 Response Details:');
      responseBody.forEach((key, value) {
        print('   $key: $value');
      });

      // Comprehensive success checking
      bool isRemovalSuccessful = responseBody['status'] == true ||
          responseBody['msg'] == 'catch all' ||
          responseBody['message'] == 'Product removed successfully';

      print('🏁 Removal Successful: $isRemovalSuccessful');

      if (isRemovalSuccessful) {
        // Immediately remove from local list
        setState(() {
          _favoriteProducts
              .removeWhere((product) => product['id'] == productId);
          print('🗑️ Locally Removed Product: $productId');
        });

        // Force a complete refresh of favorite products
        try {
          await _fetchFavoriteProducts(token);

          // Verify removal
          bool isProductStillInList =
              _favoriteProducts.any((product) => product['id'] == productId);
          print('🕵️ Product Still in List: $isProductStillInList');

          if (isProductStillInList) {
            // Detailed verification
            await _verifyProductRemoval(token, productId);
          } else {
            // Successful removal
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Product removed from favorites'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (refreshError) {
          print('❌ Error refreshing favorites: $refreshError');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error refreshing favorites: $refreshError'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Handle case where API returns unexpected response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to remove product: ${responseBody['msg'] ?? responseBody['message'] ?? 'Unknown error'}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ Error Removing Favorite: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error removing product: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Additional method to verify product removal
  Future<void> _verifyProductRemoval(String token, String productId) async {
    try {
      // Fetch current favorite products directly
      final url = Uri.parse(
          'https://alsaifgallery.onrender.com/api/v1/user/getFavoriteProducts');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('🔍 Verification Response Status: ${response.statusCode}');
      print('🔍 Verification Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // Check if product is in favorites
        final favoriteProducts =
            responseBody['user']['favoriteProducts'] as List;

        // Log all favorite product IDs
        print('🚨 Current Favorite Product IDs:');
        favoriteProducts.forEach((product) {
          print('   ${product['_id']}');
        });

        final isProductInFavorites =
            favoriteProducts.any((product) => product['_id'] == productId);

        print('🚨 Verification - Product in Favorites: $isProductInFavorites');

        if (isProductInFavorites) {
          // Last resort: show warning
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Failed to remove product $productId from favorites'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          // Successful removal
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product successfully removed from favorites'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Verification Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildProductImage(String? imageUrl) {
    print('🖼️ Building Product Image: $imageUrl');

    if (imageUrl == null || imageUrl.isEmpty) {
      print('❌ Image URL is null or empty');
      return const Icon(Icons.image_not_supported, size: 50);
    }

    return Image.network(
      imageUrl,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          print('✅ Image Loaded Successfully');
          return child;
        }
        print('⏳ Image Loading Progress: '
            '${loadingProgress.cumulativeBytesLoaded} / '
            '${loadingProgress.expectedTotalBytes ?? 'unknown'}');
        return const CircularProgressIndicator();
      },
      errorBuilder: (context, error, stackTrace) {
        print('❌ Image Load Error: $error');
        print('❌ Stack Trace: $stackTrace');

        // Try to diagnose the error
        if (error is NetworkImageLoadException) {
          print('🌐 Status Code: ${error.statusCode}');
        }

        return const Icon(Icons.image_not_supported, size: 50);
      },
    );
  }

  Widget _buildFavoriteProductCard(Map<String, dynamic> product) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                _buildProductImage(product['image']),
                const SizedBox(width: 16),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] ?? 'Unknown Product',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price: ${product['price'] ?? 'N/A'}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Category: ${product['category'] ?? 'N/A'}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Delete Icon
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.red,
                size: 24,
              ),
              onPressed: () {
                // Confirm before removing
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Remove from Favorites'),
                      content: const Text(
                          'Are you sure you want to remove this product from favorites?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                        TextButton(
                          child: const Text('Remove'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            _removeFavoriteProduct(
                                product['id']); // Remove the product
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Comprehensive logging in build method
    print('🏗️ Build Method:');
    print('🔒 Is Logged In: $_isLoggedIn');
    print('⏳ Is Loading: $_isLoading');
    print('📦 Favorite Products Count: ${_favoriteProducts.length}');

    if (_isCheckingLogin) {
      return const Scaffold(
          body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: SizedBox(
            height: 220,
            width: 220,
            child: const Image(
              image: AssetImage('assets/images/loading-gif.gif'),
            ),
          ),
        ),
      ));
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
            child: _isLoading
                ? const Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: SizedBox(
                        height: 220,
                        width: 220,
                        child: const Image(
                          image: AssetImage('assets/images/loading-gif.gif'),
                        ),
                      ),
                    ),
                  )
                : _favoriteProducts.isEmpty
                    ? Center(
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
                              style:
                                  TextStyle(fontSize: 11, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 185, 41, 30),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 90, vertical: 13),
                                textStyle: const TextStyle(fontSize: 16),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              child: const Text(
                                'Continue Shopping',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _favoriteProducts.length,
                        itemBuilder: (context, index) {
                          final product = _favoriteProducts[index];
                          return _buildFavoriteProductCard(product);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
