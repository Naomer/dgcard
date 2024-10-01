import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:alsaif_gallery/app/cartscreen.dart';
import 'package:alsaif_gallery/app/categories_screen.dart';
import 'package:alsaif_gallery/app/favorites_screen.dart';
import 'package:alsaif_gallery/app/account.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:alsaif_gallery/localization/applocalizations.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  Color bColor = Colors.white;
  late TabController _tabController;

  final List<String> _categories = [
    'All',
    'Big Home Appliances',
    'Electrical Appliances',
    'Best Categories',
    'Kitchenware',
    'Serveware',
    'Home Appliances',
  ];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.format_list_bulleted,
    Icons.shopping_cart_outlined,
    Icons.local_offer_outlined,
    Icons.account_circle_outlined,
  ];

  final List<String> _labels = [
    'Home',
    'Categories',
    'Cart',
    'Offers',
    'Account',
  ];

  final List<Widget> _widgetOptions = <Widget>[
    const Text('Home Page'),
    CategoriesScreen(),
    CartScreen(),
    const Text('Offers'),
    Account(),
  ];

  // List of images for the top carousel slider
  final List<String> _topBanners = [
    'assets/payment_banner.png',
    'assets/paywitharab.png',
  ];

  // List of images for the main carousel slider
  final List<String> _mainBanners = [
    'assets/50perbanner.png',
    'assets/banner2.png',
    'assets/banner3.png',
    'assets/banner4.png',
    'assets/banner5.png',
  ];

  int _currentMainBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bColor,
      appBar: _selectedIndex == 2
          ? null // Remove AppBar when in CartScreen
          : AppBar(
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
                        SizedBox(width: 0),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'What are you looking for?',
                                hintStyle: TextStyle(
                                  fontSize: 13,
                                  color:
                                      const Color.fromARGB(255, 150, 149, 149),
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 248, 248, 248),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 0),
                        IconButton(
                          icon: Icon(
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
      body: _selectedIndex == 0
          ? Column(
              children: [
                // Custom TabBar with vertical lines and adjusted spacing
                Container(
                  color: const Color.fromARGB(
                      255, 248, 248, 248), // TabBar background color
                  height: 32.0, // Adjust TabBar height if needed
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelStyle: TextStyle(
                        fontSize: 10, // Adjust font size
                        fontWeight: FontWeight.bold), // Font weight
                    unselectedLabelStyle: TextStyle(
                        fontSize: 10), // Font size for unselected label
                    indicator: BoxDecoration(
                      color:
                          Colors.transparent, // Background color of indicator
                      border: Border(
                        bottom: BorderSide(
                          color: const Color.fromARGB(
                              255, 187, 26, 14), // Underline color
                          width: 2, // Underline width
                        ),
                      ),
                    ),
                    tabs: List.generate(_categories.length, (index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0), // Reduce horizontal padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _categories[index],
                              style: TextStyle(color: Colors.black),
                            ),
                            if (index < _categories.length - 1)
                              Container(
                                width: 1, // Line width
                                height: 35, // Line height
                                color: const Color.fromARGB(255, 189, 186, 186),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 4), // Adjust margin
                              ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),

                // Show carousel sliders only if "All" category is selected
                if (_tabController.index == 0) ...[
                  // Top carousel slider
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 37.0,
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
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                            ),
                            child: Image.asset(banner, fit: BoxFit.cover),
                          );
                        },
                      );
                    }).toList(),
                  ),

                  // Main carousel slider
                  Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 220.0,
                          autoPlay: true,
                          viewportFraction: 1.0,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentMainBannerIndex = index;
                            });
                          },
                        ),
                        items: _mainBanners.map((banner) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                ),
                                child: Image.asset(banner, fit: BoxFit.cover),
                              );
                            },
                          );
                        }).toList(),
                      ),

                      // Page indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _mainBanners.length,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            width: 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentMainBannerIndex == index
                                  ? const Color.fromARGB(255, 189, 20, 8)
                                  : const Color.fromARGB(255, 189, 189, 189),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                Expanded(
                  child: Container(
                    color: Colors.white, // Main screen background color
                    child: TabBarView(
                      controller: _tabController,
                      children: _categories.map((category) {
                        // Show content conditionally based on category
                        if (category == 'All') {
                          return Container(); // Placeholder if no content is needed for "All"
                        } else {
                          return Center(
                            child: Text(
                              category, // Display category content
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                      }).toList(),
                    ),
                  ),
                ),
              ],
            )
          : _widgetOptions[_selectedIndex], // For other screens
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: bColor,
        color: const Color.fromARGB(255, 243, 241, 241),
        buttonBackgroundColor: const Color.fromARGB(255, 243, 241, 241),
        height: 70,
        animationDuration: Duration(milliseconds: 300),
        items: _icons.asMap().entries.map((entry) {
          int index = entry.key;
          IconData iconData = entry.value;
          return Container(
            padding: EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  size: 27,
                  color: _selectedIndex == index
                      ? const Color.fromARGB(255, 196, 41, 30)
                      : const Color.fromARGB(255, 80, 80, 80),
                ),
                SizedBox(height: 2),
                Text(
                  _labels[index],
                  style: TextStyle(
                    color: _selectedIndex == index
                        ? const Color.fromARGB(255, 189, 20, 8)
                        : const Color.fromARGB(255, 80, 80, 80),
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onTap: _onItemTapped,
        index: _selectedIndex,
      ),
    );
  }
}
