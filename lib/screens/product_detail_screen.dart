import 'package:alsaif_gallery/screens/SearchScreen.dart';
import 'package:alsaif_gallery/screens/favorites_screen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:alsaif_gallery/provider/CartProvider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  ProductDetailScreen({
    required this.productId,
    required Map product,
    required Null Function() onCompletePurchase,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Map<String, dynamic> productData;
  int quantity = 1;
  bool showPopup = false;
  double _rating = 0.0;
  TextEditingController _commentController = TextEditingController();
  String activeSection = 'Description'; // Default section is Description
  final PageController _pageController = PageController();

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

  void submitRating() {
    if (_rating > 0) {
      // Handle rating submission (e.g., call an API to submit the rating)
      print('Rating: $_rating');
      if (_commentController.text.isNotEmpty) {
        print('Comment: ${_commentController.text}');
      }
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
                    builder: (context) => FavoritesScreen(
                      token: 'token',
                    ),
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
                      'Total product in stock: ${productData['stockQuantity']}',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    // Product Image Carousel with arrows
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 250,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: productData['imageIds'].length,
                            itemBuilder: (context, index) {
                              return Image.network(
                                productData['imageIds'][index],
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Page indicator
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: productData['imageIds'].length,
                        effect: WormEffect(
                          dotColor: Colors.grey,
                          activeDotColor: Colors.red,
                          dotHeight: 8,
                          dotWidth: 8,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Product Name
                    Text(
                      productData['name'] ?? 'No name',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    // Rating System
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _rating = index + 1.0;
                            });
                          },
                          child: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color:
                                index < _rating ? Colors.yellow : Colors.grey,
                            size: 20,
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 10),
                    // Add comment popup
                    if (_rating > 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Add a comment (optional):'),
                          TextField(
                            controller: _commentController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'Your comment...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _rating = 0.0;
                                    _commentController.clear();
                                  });
                                },
                                child: Text('Cancel'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: Colors.grey),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  minimumSize: Size(60, 30),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: submitRating,
                                child: Text('Submit'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      const Color.fromARGB(255, 148, 43, 209),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  minimumSize: Size(80, 30),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    SizedBox(height: 10),
                    // Category or Brand
                    Text(
                      'Category: ${productData['category']['categoryName'] ?? 'No category'}',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    // Product Price
                    Text(
                      'Price: \$${productData['price']}',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),

                    SizedBox(height: 20),
                    // Add to Cart button
                    Center(
                      child: ElevatedButton(
                        onPressed: addToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width * 0.9, 47),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: Text('ADD TO CART'),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Bottom Section (Tapping text switches content)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              activeSection = 'Description';
                            });
                          },
                          child: Text(
                            'Description',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: activeSection == 'Description'
                                    ? Colors.red
                                    : Colors.black),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              activeSection = 'Additional Information';
                            });
                          },
                          child: Text(
                            'Additional Information',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: activeSection == 'Additional Information'
                                    ? Colors.red
                                    : Colors.black),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              activeSection = 'Ratings';
                            });
                          },
                          child: Text(
                            'Ratings',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: activeSection == 'Ratings'
                                    ? Colors.red
                                    : Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Displaying the selected section content
                    if (activeSection == 'Description')
                      Text(productData['description'] ?? 'No description'),
                    if (activeSection == 'Additional Information')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                              'SKU: ${productData['additionalInformation']['SKU']}'),
                          Text(
                              'Brand: ${productData['additionalInformation']['brand']}'),
                          Text(
                              'Color: ${productData['additionalInformation']['color']}'),
                          Text(
                              'Size: ${productData['additionalInformation']['size']}'),
                          Text(
                              'Material: ${productData['additionalInformation']['material']}'),
                          Text(
                              'Warranty: ${productData['additionalInformation']['warranty']}'),
                          Text(
                              'Return Policy: ${productData['additionalInformation']['returnPolicy']}'),
                        ],
                      ),
                    if (activeSection == 'Ratings')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display the average rating with stars
                          Row(
                            children: [
                              // Single yellow star icon
                              Icon(
                                Icons.star,
                                color: const Color.fromARGB(255, 243, 219, 5),
                                size: 16,
                              ),
                              SizedBox(
                                  width:
                                      4), // Spacing between the star and text
                              // Display the formatted rating and the number of ratings
                              Text(
                                ' ${productData['ratings']?['averageRating']?.toStringAsFixed(2) ?? '0.00'}'
                                '${(productData['ratings']?['numberOfRatings'] ?? 0) > 1000 ? ' (1000+)' : ''}', // Conditional "(1000+)"
                                style:
                                    TextStyle(fontSize: 16), // Optional styling
                              ),
                            ],
                          ),

                          SizedBox(height: 8),

                          // Display the number of ratings
                          Text(
                            '${productData['ratings']?['numberOfRatings'] ?? 0} Customers Rated this product.',
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(height: 10),
                          // Display individual user ratings
                          if (productData['ratings']?['ratingsByUser'] != null)
                            ...productData['ratings']['ratingsByUser']
                                .map<Widget>((ratingData) {
                              final userId = ratingData['userId'];
                              final lastName = userId?['lastName'] ?? 'Unknown';
                              final anonymizedLastName =
                                  '${lastName[0]}***${lastName[lastName.length - 1]}';

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // Display anonymized name
                                      Text(
                                        anonymizedLastName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      // Display user rating with stars
                                      ...List.generate(5, (index) {
                                        return Icon(
                                          index < (ratingData['rating'] ?? 0)
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: const Color.fromARGB(
                                              255, 243, 219, 5),
                                          size: 16,
                                        );
                                      }),
                                    ],
                                  ),
                                  // Display user comment
                                  Text(
                                    ratingData['comment'] ??
                                        'No comment provided',
                                    style: TextStyle(
                                      fontSize:
                                          12, // Adjust the font size to your preference
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Divider(
                                    color: Colors.grey, // Color of the line
                                    thickness: 0.5, // Thickness of the line
                                    height:
                                        16, // Space above and below the line
                                  ),
                                ],
                              );
                            }).toList(),
                        ],
                      ),
                    SizedBox(height: 20),
                    // Add to Cart button
                  ],
                ),
              ),
            ),
    );
  }
}
