import 'package:alsaif_gallery/screens/SearchScreen.dart';
import 'package:alsaif_gallery/screens/favorites_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:alsaif_gallery/api/product_api.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  final String categoryId;
  final String subCategoryId;

  const ProductsScreen({
    super.key,
    required this.categoryId,
    required this.subCategoryId,
  });

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List products = [];
  final ProductApi apiService = ProductApi();
  List<Map<String, dynamic>> favoriteProducts = [];

  void addToFavorites(Map<String, dynamic> product) {
    setState(() {
      if (!favoriteProducts.contains(product)) {
        favoriteProducts.add(product);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await apiService
        .get('/api/v1/product/getProductByCategories/${widget.subCategoryId}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        products = data['data'];
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    builder: (context) => FavoritesScreen(favoriteProducts: []),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: products.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 5),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          productId: product['_id'],
                          product: product,
                          onCompletePurchase: () {},
                        ),
                      ),
                    );
                  },
                  child: Container(
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
                                product['name'],
                                style: const TextStyle(),
                              ),
                            ),
                            if (hasDiscount)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '${product['price']}',
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'SAR ${product['discount'] ?? product['price']}',
                                style: const TextStyle(
                                  color: const Color.fromARGB(255, 194, 6, 6),
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
                                color: const Color.fromARGB(255, 194, 6, 6),
                                borderRadius: BorderRadius.circular(4.0),
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
                              color: Color.fromARGB(255, 143, 77, 77),
                            ),
                            onPressed: () {
                              addToFavorites(product);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
