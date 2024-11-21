import 'package:alsaif_gallery/screens/SearchScreen.dart';
import 'package:alsaif_gallery/screens/favorites_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alsaif_gallery/provider/CartProvider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  ProductDetailScreen(
      {required this.productId,
      required Map product,
      required Null Function() onCompletePurchase});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Map<String, dynamic> productData;
  int quantity = 1;
  bool showPopup = false;

  @override
  void initState() {
    super.initState();
    productData = {};
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      final baseUrl = 'http://alsaifgallery.onrender.com';
      final url =
          '$baseUrl/api/v1/product/getSingleProduct/${widget.productId}';
      final response = await Dio().get(url);

      if (response.statusCode == 200) {
        setState(() {
          productData = response.data['data'];
        });
      } else {
        print('Failed to fetch product details');
      }
    } catch (e) {
      print('Error fetching product details: $e');
    }
  }

  void addToCart() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addToCart(productData, quantity);
    setState(() {
      showPopup = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showPopup = false;
        });
      }
    });
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
      body: productData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productData['name'] ?? 'No name',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Category: ${productData['category']['categoryName'] ?? 'No category'}',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Text(
                      productData['description'] ?? 'No description',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Price: \$${productData['price']}',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Stock Quantity: ${productData['stockQuantity']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productData['imageIds'].length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Image.network(
                              productData['imageIds'][index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Additional Information:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text('SKU: ${productData['additionalInformation']['SKU']}'),
                    Text(
                        'Brand: ${productData['additionalInformation']['brand']}'),
                    Text(
                        'Color: ${productData['additionalInformation']['color']}'),
                    Text(
                        'Material: ${productData['additionalInformation']['material']}'),
                    Text(
                        'Warranty: ${productData['additionalInformation']['warranty']}'),
                    SizedBox(height: 10),
                    Text(
                        'Average Rating: ${productData['ratings']['averageRating']}'),
                    Text(
                        'Number of Ratings: ${productData['ratings']['numberOfRatings']}'),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 16),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) quantity--;
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('$quantity',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: ElevatedButton(
                onPressed: addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 194, 6, 6),
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text('Add to Cart',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: showPopup
          ? Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: AlertDialog(
                    title: const Icon(Icons.check_circle_outline,
                        color: Colors.green, size: 48),
                    content: const Text(
                      'Your choice has been successfully added to the cart.',
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showPopup = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          minimumSize: Size(150, 60),
                        ),
                        child: const Text(
                          'You see your added items in cart',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text(
                          'Okay',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
