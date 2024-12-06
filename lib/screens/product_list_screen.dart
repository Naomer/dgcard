import 'dart:convert';
import 'package:alsaif_gallery/provider/FavoriteProvider.dart';
import 'package:alsaif_gallery/screens/SearchScreen.dart';
import 'package:alsaif_gallery/screens/favorites_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<dynamic> products = [];
  String selectedSort = 'popularity';
  bool isLoading = true;
  Map<String, bool> filterOptions = {
    'Size': false,
    'Color': false,
    'Function': false,
    'Brand': false,
    'Material': false,
    'Price': false,
  };

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://alsaifgallery.onrender.com/api/v1/product/getAllProducts?hasDiscount=true",
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null &&
            data['data'] != null &&
            data['data']['products'] is List) {
          setState(() {
            products =
                List<Map<String, dynamic>>.from(data['data']['products']);
            applyLocalSort(); // Apply sort after fetching data
            isLoading = false; // End loading state after fetching
          });
        } else {
          throw Exception('"products" is not a list or is null');
        }
      } else {
        throw Exception(
            'Failed to fetch products with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        isLoading = false; // Ensure loading stops even on error
      });
    }
  }

  void applyLocalSort() {
    setState(() {
      if (selectedSort == "priceHighToLow") {
        products.sort((a, b) => b['price'].compareTo(a['price']));
      } else if (selectedSort == "priceLowToHigh") {
        products.sort((a, b) => a['price'].compareTo(b['price']));
      } else if (selectedSort == "popularity") {
        products.sort((a, b) => b['popularity'].compareTo(a['popularity']));
      }
    });
  }

  void showSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Adjust the curve here
          ),
          title: Center(
            child: Text(
              'Sort By',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 0.0), // Remove padding
                  title: Row(
                    children: [
                      Radio<String>(
                        value: "popularity",
                        groupValue: selectedSort,
                        onChanged: (value) {
                          setState(() {
                            selectedSort = value!;
                          });
                          fetchProducts();
                          Navigator.pop(context);
                        },
                        activeColor: const Color.fromARGB(255, 158, 37, 28),
                      ),
                      Text(
                        'Popularity',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color.fromARGB(255, 107, 107, 107),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0, bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 1,
                        width: 177,
                        color: const Color.fromARGB(255, 209, 209, 209),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 0.0), // Remove padding
                  title: Row(
                    children: [
                      Radio<String>(
                        value: "priceHighToLow",
                        groupValue: selectedSort,
                        onChanged: (value) {
                          setState(() {
                            selectedSort = value!;
                          });
                          fetchProducts();
                          Navigator.pop(context);
                        },
                        activeColor: const Color.fromARGB(255, 160, 39, 30),
                      ),
                      Text(
                        'Price: High to Low',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color.fromARGB(255, 107, 107, 107),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0, bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 1,
                        width: 177,
                        color: const Color.fromARGB(255, 209, 209, 209),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 0.0), // Remove padding
                  title: Row(
                    children: [
                      Radio<String>(
                        value: "priceLowToHigh",
                        groupValue: selectedSort,
                        onChanged: (value) {
                          setState(() {
                            selectedSort = value!;
                          });
                          fetchProducts();
                          Navigator.pop(context);
                        },
                        activeColor: const Color.fromARGB(255, 160, 35, 26),
                      ),
                      Text(
                        'Price: Low to High',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color.fromARGB(255, 117, 117, 117),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final discountedProducts = products.where((product) {
      return product.containsKey('discount') && product['discount'] != null;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/loggo.png', height: 33),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            SearchScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 35.0,
                    child: TextField(
                      enabled: false, // Disable editing
                      decoration: InputDecoration(
                        hintText: 'Find it here...',
                        hintStyle:
                            TextStyle(fontSize: 13.0, color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 14.0),
                        suffixIcon: Icon(Icons.search,
                            color: Colors.grey[600], size: 20.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FavoritesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            color: Color.fromARGB(255, 204, 204, 204),
            thickness: 1.1,
            height: 1.0,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  'Daily Offers',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(width: 8),
                Text(
                  '(${discountedProducts.length} products)',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: const [
                  Divider(
                    color: Color.fromARGB(255, 219, 219, 219),
                    thickness: 1.0,
                  ),
                  SizedBox(height: 6),
                ],
              ),
            ],
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: discountedProducts.length,
                    itemBuilder: (context, index) {
                      var product = discountedProducts[index];
                      return ListTile(
                        title: Text(product['name']),
                        subtitle: Text('Price: \$${product['price']}'),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
