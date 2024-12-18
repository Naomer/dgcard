import 'package:alsaif_gallery/services/api_service.dart';
import 'package:alsaif_gallery/screens/SearchScreen.dart';
import 'package:alsaif_gallery/screens/favorites_screen.dart';
import 'package:alsaif_gallery/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class CategoryScreen extends StatefulWidget {
  final void Function(Map<String, dynamic> product) onProductSelected;

  const CategoryScreen({Key? key, required this.onProductSelected})
      : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ApiService apiService = ApiService();
  List<dynamic> parentCategories = [];
  List<dynamic> subCategories = [];
  List<dynamic> allProducts = [];
  List<dynamic> filteredProducts = [];
  bool isLoadingParent = true;
  bool isLoadingSub = false;
  bool isLoadingSearch = false;
  String selectedParentCategoryId = '';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchParentCategories();
    fetchAllProducts();
  }

  Future<void> fetchParentCategories() async {
    try {
      final response =
          await apiService.get('/api/v1/category/getParentCategories');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true && data['data'] != null) {
          setState(() {
            parentCategories = data['data'];
            isLoadingParent = false;
          });

          if (parentCategories.isNotEmpty) {
            selectParentCategory(parentCategories[0]['_id']);
          }
        } else {
          setState(() {
            isLoadingParent = false;
          });
        }
      } else {
        setState(() {
          isLoadingParent = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingParent = false;
      });
    }
  }

  Future<void> fetchAllProducts() async {
    setState(() {
      isLoadingSearch = true;
    });

    try {
      final response = await apiService.get('/api/v1/products/getAllProducts');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          allProducts = data['data'] ?? [];
          filteredProducts = allProducts;
          isLoadingSearch = false;
        });
      } else {
        setState(() {
          isLoadingSearch = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingSearch = false;
      });
    }
  }

  void filterProducts(String query) {
    setState(() {
      searchQuery = query;
      filteredProducts = allProducts
          .where((product) => product['name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> fetchSubCategories(String parentId) async {
    setState(() {
      isLoadingSub = true;
    });

    try {
      final response =
          await apiService.get('/api/v1/category/subCategories/$parentId');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          subCategories = data['data'] ?? [];
          isLoadingSub = false;
        });
      } else {
        setState(() {
          isLoadingSub = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingSub = false;
      });
    }
  }

  void selectParentCategory(String parentId) {
    setState(() {
      selectedParentCategoryId = parentId;
      subCategories = [];
    });
    fetchSubCategories(parentId);
  }

  void navigateToProducts(String subCategoryId, String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsScreen(
          subCategoryId: subCategoryId,
          categoryId: selectedParentCategoryId, // If needed
          categoryName: categoryName, // Pass the category name
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 0, // Ensures the title starts at the left edge
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0), // Adjust this for minimal space
                child: Image.asset('assets/loggo.png', height: 36),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
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
                          hintStyle: TextStyle(
                              fontSize: 13.0, color: Colors.grey[600]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 245, 244, 244),
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
            ],
          ),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.only(right: 1.0), // Fine-tune this if needed
              child: IconButton(
                icon: const Icon(Icons.favorite_border,
                    color: Color.fromARGB(255, 107, 106, 106)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritesScreen()),
                  );
                },
              ),
            ),
          ],
        ),
        body: Column(children: [
          Divider(
            height: 1.0,
            color: Colors.grey[300],
          ),
          Expanded(
            child: searchQuery.isNotEmpty
                ? isLoadingSearch
                    ? const Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: SizedBox(
                            height: 220,
                            width: 220,
                            child: const Image(
                              image:
                                  AssetImage('assets/images/loading-gif.gif'),
                            ),
                          ),
                        ),
                      )
                    : filteredProducts.isEmpty
                        ? const Center(child: Text("No products found"))
                        : ListView.builder(
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              return ListTile(
                                title:
                                    Text(product['name'] ?? 'Unnamed Product'),
                                onTap: () {},
                              );
                            },
                          )
                : Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        color: Colors.grey[200],
                        child: isLoadingParent
                            ? const Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 50),
                                  child: SizedBox(
                                    height: 220,
                                    width: 100,
                                    child: const Image(
                                      image: AssetImage(
                                          'assets/images/loading-gif.gif'),
                                    ),
                                  ),
                                ),
                              )
                            : parentCategories.isEmpty
                                ? const Center(
                                    child: Text("No categories available"))
                                : ListView.builder(
                                    itemCount: parentCategories.length,
                                    itemBuilder: (context, index) {
                                      final category = parentCategories[index];
                                      final categoryName =
                                          category['categoryName'] ?? 'No Name';
                                      final categoryLogoUrl =
                                          category['categoryLogo']?['data'];
                                      final isSelected = category['_id'] ==
                                          selectedParentCategoryId;

                                      return GestureDetector(
                                        onTap: () {
                                          selectParentCategory(category['_id']);
                                        },
                                        child: Container(
                                          color: isSelected
                                              ? Colors.grey[300]
                                              : Colors.transparent,
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
                                                      size: 45),
                                              const SizedBox(height: 15),
                                              Text(
                                                categoryName,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                              const Divider(),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                      ),
                      Expanded(
                        flex: 3,
                        child: isLoadingSub
                            ? const Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 50),
                                  child: SizedBox(
                                    height: 220,
                                    width: 220,
                                    child: const Image(
                                      image: AssetImage(
                                          'assets/images/loading-gif.gif'),
                                    ),
                                  ),
                                ),
                              )
                            : subCategories.isEmpty
                                ? const Center(
                                    child: Text("No subcategories available"))
                                : GridView.builder(
                                    padding: const EdgeInsets.all(8.0),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 9.0,
                                      mainAxisSpacing: 9.0,
                                      childAspectRatio: 0.8,
                                    ),
                                    itemCount: subCategories.length,
                                    itemBuilder: (context, index) {
                                      final subCategory = subCategories[index];
                                      final subCategoryName =
                                          subCategory['categoryName'] ??
                                              'No Name';
                                      final categoryLogoUrl =
                                          subCategory['categoryLogo']
                                                  ?['data'] ??
                                              '';

                                      return GestureDetector(
                                        onTap: () {
                                          navigateToProducts(
                                            subCategory['_id'],
                                            subCategory['categoryName'] ??
                                                'No Name', // Pass the category name
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: categoryLogoUrl.isNotEmpty
                                                  ? Image.network(
                                                      categoryLogoUrl,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          const Icon(
                                                              Icons
                                                                  .image_not_supported,
                                                              size: 45),
                                                    )
                                                  : const Icon(Icons.category,
                                                      size: 45),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              subCategoryName,
                                              style:
                                                  const TextStyle(fontSize: 12),
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
          )
        ]));
  }
}
