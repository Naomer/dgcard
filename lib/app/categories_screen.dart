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
    // {'name': 'Product 7', 'image': 'assets/product7.png'},
    // {'name': 'Product 8', 'image': 'assets/product8.png'},
    // {'name': 'Product 9', 'image': 'assets/product9.png'},
    // {'name': 'Product 10', 'image': 'assets/product10.png'},
  ];

  // Map to store banner images for each category
  final Map<String, String> categoryBanners = {
    'Electrical\nAppliances': 'assets/electrical_appliances_banner.png',
    'Best\nCategories': 'assets/best_categories.png',
    'Kitchenware': 'assets/kitchenware.png',
    //'Televisions': 'assets/televisions_banner.png',
    'Large Home\nAppliances': 'assets/large_home.png',
    'Serveware': 'assets/serveware.png',
    'Home\nAppliances': 'assets/home_appliances.png',
  };

  @override
  void initState() {
    super.initState();
    // Ensure "Electrical Appliances" is selected by default when the screen opens or reopens
    selectedCategory = 'Electrical\nAppliances';
  }

  void _selectCategory(String categoryName) {
    setState(() {
      selectedCategory = categoryName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side category list
          Container(
            width: 97, // Width for the left-side list
            color: const Color.fromARGB(
                255, 248, 247, 247), // Background color for the list
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 10), // Vertical padding for each item
                        // Set background color: white for selected, gray for unselected
                        color: isSelected
                            ? Colors.white
                            : const Color.fromARGB(255, 245, 243, 243),
                        child: Row(
                          children: [
                            // Red vertical line indicator when selected
                            Container(
                              width: 4, // Width of the red vertical line
                              height:
                                  80, // Adjust height of the red vertical line
                              color: isSelected
                                  ? const Color.fromARGB(255, 211, 38, 26)
                                  : Colors.transparent,
                            ),
                            const SizedBox(
                                width: 15), // Space between red line and icon
                            Column(
                              children: [
                                // Icon
                                Icon(
                                  category['icon'],
                                  size: isBestCategories
                                      ? 40.0
                                      : 25.0, // Custom size for 'Best Categories'
                                  color: isSelected
                                      ? const Color.fromARGB(255, 211, 38, 26)
                                      : const Color.fromARGB(
                                          255, 155, 153, 153),
                                ),
                                const SizedBox(
                                    height: 10), // Space between icon and text
                                // Category name
                                Text(
                                  category['name'],
                                  style: TextStyle(
                                      fontSize: 10, // Smaller text size
                                      color: isSelected
                                          ? const Color.fromARGB(
                                              255, 187, 31, 20)
                                          : const Color.fromARGB(255, 114, 114,
                                              114) // Default black text
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Add grey divider between categories
                      Divider(
                        thickness: 1,
                        color: Colors.grey[300], // Grey line color
                        height: 0, // Remove extra height for the divider
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Right side showing the selected category and products
          Expanded(
            child: Column(
              children: [
                // Display banner for the selected category
                if (categoryBanners[selectedCategory] != null) ...[
                  Image.asset(
                    categoryBanners[selectedCategory]!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  const SizedBox(
                      height: 10), // Space between image and product list
                ],
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Three columns per row
                      crossAxisSpacing: 10, // Horizontal space between items
                      mainAxisSpacing: 10, // Vertical space between items
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Product image
                          Image.asset(
                            product['image']!,
                            fit: BoxFit.cover,
                            width: 60, // Adjust width as needed
                            height: 60, // Adjust height as needed
                          ),
                          const SizedBox(
                              height: 5), // Space between image and text
                          // Product name
                          Text(
                            product['name']!,
                            style: const TextStyle(fontSize: 8),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
