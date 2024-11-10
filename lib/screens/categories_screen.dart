import 'package:alsaif_gallery/api/api_service.dart';
import 'package:alsaif_gallery/screens/product/products_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ApiService apiService = ApiService();
  List<dynamic> parentCategories = [];
  List<dynamic> subCategories = [];
  bool isLoadingParent = true;
  bool isLoadingSub = false;

  @override
  void initState() {
    super.initState();
    fetchParentCategories();
  }

  Future<void> fetchParentCategories() async {
    try {
      final response =
          await apiService.get('/api/v1/category/getParentCategories');

      // Debugging: Print the response body
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true && data['data'] != null) {
          setState(() {
            parentCategories = data['data'];
            isLoadingParent = false;
          });

          // Automatically load subcategories for the first parent category
          if (parentCategories.isNotEmpty) {
            fetchSubCategories(parentCategories[0]['_id']);
          }
        } else {
          print("Unexpected data format: ${data}");
          setState(() {
            isLoadingParent = false;
          });
        }
      } else {
        print(
            'Failed to load parent categories with status code: ${response.statusCode}');
        setState(() {
          isLoadingParent = false;
        });
      }
    } catch (e) {
      print('Error fetching parent categories: $e');
      setState(() {
        isLoadingParent = false;
      });
    }
  }

  Future<void> fetchSubCategories(String parentId) async {
    setState(() {
      isLoadingSub = true;
    });

    try {
      final response =
          await apiService.get('/api/v1/category/subCategories/$parentId');

      print("Subcategories response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          subCategories = data['data'] ?? [];
          isLoadingSub = false;
        });
      } else {
        print(
            'Failed to load subcategories with status code: ${response.statusCode}');
        setState(() {
          isLoadingSub = false;
        });
      }
    } catch (e) {
      print('Error fetching subcategories: $e');
      setState(() {
        isLoadingSub = false;
      });
    }
  }

  void navigateToProducts(String subCategoryId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsScreen(subCategoryId: subCategoryId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left side: Parent Categories
          Container(
            width: MediaQuery.of(context).size.width *
                0.25, // Set width to 25% of screen width
            color: Colors.grey[200], // Light gray background
            child: isLoadingParent
                ? const Center(child: CircularProgressIndicator())
                : parentCategories.isEmpty
                    ? const Center(child: Text("No categories available"))
                    : ListView.builder(
                        itemCount: parentCategories.length,
                        itemBuilder: (context, index) {
                          final category = parentCategories[index];
                          final categoryName =
                              category['categoryName'] ?? 'No Name';
                          final categoryLogoUrl =
                              category['categoryLogo']?['data'];

                          return GestureDetector(
                            onTap: () {
                              fetchSubCategories(category['_id']);
                            },
                            child: Column(
                              children: [
                                categoryLogoUrl != null
                                    ? Image.network(
                                        categoryLogoUrl,
                                        width: 45,
                                        height: 45,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(
                                        Icons.image_not_supported,
                                        size: 45,
                                      ),
                                const SizedBox(
                                    height: 15), // Space between logo and name
                                Text(
                                  categoryName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 10),
                                ),
                                const Divider(), // Divider between items
                              ],
                            ),
                          );
                        },
                      ),
          ),
          // Right side: Subcategories
          Expanded(
            flex: 3,
            child: isLoadingSub
                ? const Center(child: CircularProgressIndicator())
                : subCategories.isEmpty
                    ? const Center(
                        child: Text("No subcategories available"),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Three items per row
                          crossAxisSpacing: 9.0,
                          mainAxisSpacing: 9.0,
                          childAspectRatio:
                              0.8, // Adjust to make images look better
                        ),
                        itemCount: subCategories.length,
                        itemBuilder: (context, index) {
                          final subCategory = subCategories[index];
                          final subCategoryName =
                              subCategory['categoryName'] ?? 'No Name';
                          final categoryLogoUrl =
                              subCategory['categoryLogo']?['data'] ?? '';

                          return GestureDetector(
                            onTap: () {
                              navigateToProducts(subCategory['_id']);
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: categoryLogoUrl.isNotEmpty
                                      ? Image.network(
                                          categoryLogoUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error,
                                                  stackTrace) =>
                                              Icon(Icons.image_not_supported,
                                                  size: 45),
                                        )
                                      : Icon(Icons.category,
                                          size: 45), // Default icon if no image
                                ),
                                const SizedBox(
                                    height:
                                        4.0), // Space between image and text
                                Text(
                                  subCategoryName,
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          )
        ],
      ),
    );
  }
}

// Dummy ProductsScreen for navigation
// class ProductsScreen extends StatelessWidget {
//   final String subCategoryId;

//   const ProductsScreen({Key? key, required this.subCategoryId})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Products')),
//       body: Center(
//         child: Text('Displaying products for subcategory ID: $subCategoryId'),
//       ),
//     );
//   }
// }
