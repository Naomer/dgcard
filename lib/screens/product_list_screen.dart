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
  String sortBy = 'Popularity';
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

  void addToFavorites(product) {}

  void openSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sort by'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('Popularity'),
                value: 'Popularity',
                groupValue: sortBy,
                onChanged: (value) {
                  setState(() {
                    sortBy = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: Text('Price: Low to High'),
                value: 'Price: Low to High',
                groupValue: sortBy,
                onChanged: (value) {
                  setState(() {
                    sortBy = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: Text('Price: High to Low'),
                value: 'Price: High to Low',
                groupValue: sortBy,
                onChanged: (value) {
                  setState(() {
                    sortBy = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: Text('Relevance'),
                value: 'Relevance',
                groupValue: sortBy,
                onChanged: (value) {
                  setState(() {
                    sortBy = value!;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void openFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  filterOptions.updateAll((key, value) => false);
                });
                Navigator.of(context).pop();
              },
              child: Text('Clear'),
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: filterOptions.keys.map((filter) {
              return CheckboxListTile(
                title: Text(filter),
                value: filterOptions[filter],
                onChanged: (value) {
                  setState(() {
                    filterOptions[filter] = value!;
                  });
                },
              );
            }).toList(),
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
      body: isLoading
          ? Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 120),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: const Image(
                    image: AssetImage('assets/images/loading-gif.gif'),
                  ),
                ),
              ),
            )
          : products.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: SingleChildScrollView(
                      // Wrap with SingleChildScrollView to prevent overflow
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Keep content centered
                        children: [
                          SizedBox(
                            height: 240, // Adjust size of the image
                            width: 240,
                            child: const Image(
                              image:
                                  AssetImage('assets/images/cartman.png!bw700'),
                              fit: BoxFit.contain,
                            ),
                          ), // Spacing between image and text
                          const Text(
                            "Oops! No offered products found.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    // Title Section moved to the body
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.sort),
                                onPressed: openSortDialog,
                              ),
                              Text(
                                'Sort',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.filter_list),
                                onPressed: openFilterDialog,
                              ),
                              Text(
                                'Filter',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 11, horizontal: 5),
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: 0.7,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final hasDiscount = product.containsKey('discount') &&
                              product['discount'] != null;
                          final hasDiscountPercentage =
                              product.containsKey('discountPercentage') &&
                                  product['discountPercentage'] != null;

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color.fromARGB(255, 184, 183, 183),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        product['imageIds'][0],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        product['name'] ?? 'No name',
                                        style: const TextStyle(),
                                      ),
                                    ),
                                    if (hasDiscount)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          '${product['price']}',
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        'SAR ${product['discount'] ?? product['price']}',
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 194, 6, 6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (hasDiscountPercentage)
                                  Positioned(
                                    top: 0.0,
                                    right: 0.0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 2.0),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 194, 6, 6),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Text(
                                        '${product['discountPercentage']}% \nOFF',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  top: 0.0,
                                  left: 0.0,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.favorite_border,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      addToFavorites(product);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}

// class ProductCard extends StatelessWidget {
//   final int productId;

//   ProductCard({required this.productId});

//   @override
//   Widget build(BuildContext context) {
//     final AuthProvider = Provider.of<AuthProvider>(context);
//     final Favoritesprovider = provider.of<Favoritesprovider>(context);

//     final isFavorite = favoriteProvider.favoriteProductIds.contains(productId);

//     return GestureDetector(
//       onTap: () {
//         if (!authProvider.isLoggedIn) {
//           Navigator.pushNamed(context, '/Login');
//         } else {
//           if (isFavorite) {
//             favoriteProvider.removeFromFavorites(productId);
//             _removeFavoriteProduct(productId);
//           } else {
//             favoriteprovider.addFavorite(productId);
//             _saveFavoriteProduct(productId);
//           }
//         }
//       },
//       child: Icon(
//         isFavorite ? Icons.favorite : Icons.favorite_border,
//         size: 32.0,
//         color: isFavorite ? Colors.red : Colors.grey,
//       ),
//     );
//   }

//   void _saveFavoriteProduct(int productId) {
//     // Save favorite product to local storage
//   }

//   void _removeFavoriteProduct(int productId) {
//     // Remove favorite product from local storage
//   }
// }
