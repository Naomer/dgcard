import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late String selectedCategory;

  final List<Map<String, dynamic>> categories = [
    {'name': 'Electrical\nAppliances', 'icon': FontAwesomeIcons.plug},
    {'name': 'Best\nCategories', 'icon': Icons.recommend},
    {'name': 'Kitchenware', 'icon': FontAwesomeIcons.utensils},
    {'name': 'Televisions', 'icon': FontAwesomeIcons.tv},
    {'name': 'Large Home\nAppliances', 'icon': Icons.kitchen_outlined},
    {'name': 'Serveware', 'icon': FontAwesomeIcons.mugSaucer},
    {'name': 'Home\nAppliances', 'icon': FontAwesomeIcons.blender},
  ];

  final List<Map<String, String>> products = [
    {'name': 'Coffee Maker', 'image': 'assets/coffee_maker.png'},
    {'name': 'Blender', 'image': 'assets/pressure.png'},
    {'name': 'Product 3', 'image': 'assets/blender.png'},
    {'name': 'Product 4', 'image': 'assets/blender.png'},
    {'name': 'Product 5', 'image': 'assets/blender.png'},
    {'name': 'Product 6', 'image': 'assets/blender.png'},
  ];

  // Map to store banner images for each category
  final Map<String, String> categoryBanners = {
    'Electrical\nAppliances': 'assets/electrical_appliances_banner.png',
    'Best\nCategories': 'assets/best_categories.png',
    'Kitchenware': 'assets/kitchenware.png',
    'Large Home\nAppliances': 'assets/large_home.png',
    'Serveware': 'assets/serveware.png',
    'Home\nAppliances': 'assets/home_appliances.png',
  };

  @override
  void initState() {
    super.initState();
    selectedCategory = 'Electrical\nAppliances';
  }

  void _selectCategory(String categoryName) {
    setState(() {
      selectedCategory = categoryName;
    });
  }

  void _navigateToProductList(BuildContext context, String productName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListScreen(productName: productName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side category list
          Container(
            width: 97,
            color: const Color.fromARGB(255, 248, 247, 247),
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category['name'] == selectedCategory;
                final isBestCategories = category['name'] == 'Best\nCategories';

                return GestureDetector(
                  onTap: () {
                    _selectCategory(category['name']);
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        color: isSelected
                            ? Colors.white
                            : const Color.fromARGB(255, 245, 243, 243),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 80,
                              color: isSelected
                                  ? const Color.fromARGB(255, 211, 38, 26)
                                  : Colors.transparent,
                            ),
                            const SizedBox(width: 15),
                            Column(
                              children: [
                                Icon(
                                  category['icon'],
                                  size: isBestCategories ? 40.0 : 25.0,
                                  color: isSelected
                                      ? const Color.fromARGB(255, 211, 38, 26)
                                      : const Color.fromARGB(
                                          255, 155, 153, 153),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  category['name'],
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected
                                          ? const Color.fromARGB(
                                              255, 187, 31, 20)
                                          : const Color.fromARGB(
                                              255, 114, 114, 114)),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey[300],
                        height: 0,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Column(
              children: [
                if (categoryBanners[selectedCategory] != null) ...[
                  Image.asset(
                    categoryBanners[selectedCategory]!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 10),
                ],
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return GestureDetector(
                        onTap: () {
                          _navigateToProductList(context, product['name']!);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              product['image']!,
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              product['name']!,
                              style: const TextStyle(fontSize: 8),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Screen to display a list of available products
class ProductListScreen extends StatelessWidget {
  final String productName;

  const ProductListScreen({Key? key, required this.productName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$productName Products'),
      ),
      body: Center(
        child: Text('Displaying all $productName products here.'),
      ),
    );
  }
}
