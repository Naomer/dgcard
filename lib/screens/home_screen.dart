import 'package:alsaif_gallery/screens/SearchScreen.dart';
import 'package:alsaif_gallery/screens/favorites_screen.dart';
import 'package:flutter/material.dart';
import 'package:alsaif_gallery/services/home_api_service.dart';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeApiService apiService = HomeApiService();
  List<String> parentCategories = ['All'];
  List<dynamic> advertisements = [];
  bool isLoadingParent = true;
  bool isLoadingAds = false;
  bool isLoadingSearch = false;
  String? selectedParentCategory;
  String searchQuery = '';

  List<dynamic> allProducts = [];
  List<dynamic> filteredProducts = [];
  List<dynamic> subCategoryCovers = [];
  bool isLoadingSubCategoryCovers = false;

  int _selectedIndex = 0;
  int currentIndex = 0;
  Color bColor = Colors.white;

  PageController _pageController = PageController();

  final List<String> _topBanners = [
    'assets/payment_banner.png',
    'assets/paywitharab.png',
  ];

  @override
  void initState() {
    super.initState();
    fetchParentCategories();
    fetchAdvertisements();
    fetchAllProducts();
    fetchSubCategoryCovers();
  }

  Future<void> fetchParentCategories() async {
    try {
      final response =
          await apiService.get('/api/v1/category/getParentCategories');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null) {
          setState(() {
            parentCategories.addAll(List<String>.from(data['data']
                .map((category) => category['categoryName'] ?? '')));
            selectedParentCategory =
                parentCategories.isNotEmpty ? parentCategories[0] : null;
          });
        }
      }
    } catch (e) {
      // Handle error here
    } finally {
      setState(() {
        isLoadingParent = false;
      });
    }
  }

  Future<void> fetchAdvertisements() async {
    setState(() => isLoadingAds = true);
    try {
      final response = await http.get(Uri.parse(
          "http://alsaifgallery.onrender.com/api/v1/advertisement/getSampleAdd"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          advertisements = data['data'] ?? [];
        });
      }
    } catch (e) {
      // Handle error here
    } finally {
      setState(() {
        isLoadingAds = false;
      });
    }
  }

  Future<void> fetchAllProducts() async {
    setState(() => isLoadingSearch = true);
    try {
      final response = await apiService.get('/api/v1/products/getAllProducts');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          allProducts = data['data'] ?? [];
          filteredProducts = allProducts;
        });
      }
    } catch (e) {
      // Handle error here
    } finally {
      setState(() {
        isLoadingSearch = false;
      });
    }
  }

  Future<void> fetchSubCategoryCovers() async {
    setState(() => isLoadingSubCategoryCovers = true);
    try {
      final response = await http.get(Uri.parse(
          'https://alsaifgallery.onrender.com/api/v1/category/getCoverPicturesOfSubCategories/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          subCategoryCovers = data['data'] ?? [];
        });
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() => isLoadingSubCategoryCovers = false);
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              toolbarHeight:
                  34, // Set the height of the AppBar that contains the ListView
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  height: 34,
                  color: Colors.white,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: parentCategories.length,
                    itemBuilder: (context, index) {
                      final categoryName = parentCategories[index];
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedParentCategory = categoryName;
                              });
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border(
                                  bottom: BorderSide(
                                    color: selectedParentCategory ==
                                            categoryName
                                        ? const Color.fromARGB(255, 187, 26, 14)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(categoryName,
                                  style: const TextStyle(fontSize: 11)),
                            ),
                          ),
                          if (index < parentCategories.length - 1)
                            VerticalDivider(
                                color: Colors.grey[300],
                                width: 1,
                                thickness: 1),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return buildCategoriesAndAds();
                },
                childCount: 1,
              ),
            ),
          ],
        ));
  }

  Widget buildCategoriesAndAds() {
    return Column(
      children: [
        if (selectedParentCategory != null &&
            selectedParentCategory == parentCategories.first) ...[
          CarouselSlider(
            options: CarouselOptions(
              height: 31.0,
              autoPlay: true,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {});
              },
            ),
            items: _topBanners.map((banner) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 2.0),
                    decoration: BoxDecoration(color: Colors.amber),
                    child: Image.asset(banner, fit: BoxFit.cover),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 5),
        ],
        isLoadingAds
            ? const Center(child: CircularProgressIndicator())
            : advertisements.isEmpty
                ? const Center(child: Text("No advertisements"))
                : buildAdvertisements(),
        SizedBox(height: 20),
        buildSubCategoryCovers(),
      ],
    );
  }

  Widget buildAdvertisements() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: advertisements.length,
          itemBuilder: (context, index, realIndex) {
            final ad = advertisements[index];
            final adImageUrl =
                ad['imageId'] != null ? ad['imageId']['data'] : null;

            return GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                child: adImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          adImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                  child: Icon(Icons.broken_image,
                                      size: 50, color: Colors.grey)),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.broken_image,
                            size: 50, color: Colors.grey)),
              ),
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(advertisements.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 8.0,
              width: currentIndex == index ? 20.0 : 8.0,
              decoration: BoxDecoration(
                color: currentIndex == index ? Colors.red : Colors.grey,
                borderRadius: BorderRadius.circular(5.0),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget buildSubCategoryCovers() {
    if (isLoadingSubCategoryCovers) {
      return const Center(child: CircularProgressIndicator());
    }

    if (subCategoryCovers.isEmpty) {
      return const Center(child: Text("No subcategories available"));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 8.0), // Add padding to screen edges
      child: GridView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // Prevents scrolling if nested
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two items per row
          mainAxisSpacing: 5.0, // Spacing between rows
          crossAxisSpacing: 5.0, // Spacing between columns
          childAspectRatio: 5 / 6, // Adjusted aspect ratio (wider boxes)
        ),
        itemCount: subCategoryCovers.length,
        itemBuilder: (context, index) {
          final cover = subCategoryCovers[index];
          final coverImageUrl =
              cover['coverPic']['data']; // Updated to match API response
          final subCategoryName =
              cover['subCategory']['categoryName']; // Extracted name

          return GestureDetector(
            onTap: () {
              // Handle subcategory click
              print("Tapped on $subCategoryName");
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0.0), // Add rounded corners
                image: coverImageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(coverImageUrl),
                        fit: BoxFit.cover, // Ensures image fits within box
                      )
                    : null,
                color: Colors
                    .grey[200], // Placeholder background for missing image
              ),
              child: Stack(
                children: [
                  if (coverImageUrl == null)
                    const Center(
                      child: Icon(Icons.broken_image,
                          size: 50, color: Colors.grey),
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
