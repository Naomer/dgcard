import 'package:alsaif_gallery/app/favorites_screen.dart';
import 'package:flutter/material.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatelessWidget {
  final String categoryName;
  final int _selectedIndex; // Add this field for the selected index

  ProductListScreen({required this.categoryName, required int selectedIndex})
      : _selectedIndex = selectedIndex;

  // Example product data organized by category
  final Map<String, List<Map<String, String>>> categoryProducts = {
    'Electrical\nAppliances': [
      {'name': 'Coffee Maker', 'image': 'assets/coffee_maker.png'},
      {'name': 'Blender', 'image': 'assets/blender.png'},
      {'name': 'Toaster', 'image': 'assets/toaster.png'},
      // Add more Electrical Appliances products here
    ],
    'Kitchenware': [
      {'name': 'Knife Set', 'image': 'assets/knife_set.png'},
      {'name': 'Cutting Board', 'image': 'assets/cutting_board.png'},
      {'name': 'Frying Pan', 'image': 'assets/frying_pan.png'},
      // Add more Kitchenware products here
    ],
    // Add more categories and their products
    'Serveware': [
      {'name': 'Serving Tray', 'image': 'assets/serving_tray.png'},
      {'name': 'Glass Bowl', 'image': 'assets/glass_bowl.png'},
    ],
    'Home\nAppliances': [
      {'name': 'Vacuum Cleaner', 'image': 'assets/vacuum_cleaner.png'},
      {'name': 'Air Purifier', 'image': 'assets/air_purifier.png'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    // Get the products for the selected category
    final products = categoryProducts[categoryName] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: _selectedIndex == 0 ? 0 : 0,
        title: _selectedIndex == 4
            ? Center(
                child: Image.asset(
                  'assets/favlog.png',
                  height: 120,
                ),
              )
            : Row(
                children: <Widget>[
                  Image.asset(
                    'assets/loggo.png',
                    height: 45,
                  ),
                  const SizedBox(width: 0),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'What are you looking for?',
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: Color.fromARGB(255, 150, 149, 149),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 248, 248, 248),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 0),
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoritesScreen()),
                      );
                    },
                  ),
                ],
              ),
      ),
      body: products.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to ProductDetailScreen with selected product data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                            productName: product['name']!,
                            productImage: product['image']!,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          product['image']!,
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          product['name']!,
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Text(
                'No products found for this category.',
                style: TextStyle(fontSize: 18),
              ),
            ),
    );
  }
}
