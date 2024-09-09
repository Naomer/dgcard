import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:alsaif_gallery/app/categories_screen.dart';
import 'package:alsaif_gallery/app/favorites_screen.dart';
import 'package:alsaif_gallery/app/account.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  Color bColor = Colors.white;
  int _selectedCategoryIndex = 0; // Track selected category index
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

  static List<Widget> _widgetOptions = <Widget>[
    const Text('Home Page'),
    CategoriesScreen(),
    const Text('Cart'),
    const Text('Offers'),
    Account(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedCategoryIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bColor,
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
                  SizedBox(width: 0),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'What are you looking for?',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: const Color.fromARGB(255, 150, 149, 149),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 248, 248, 248),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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

                // Image displayed below the TabBar
                Image.asset(
                  'assets/payment_banner.png', // Replace with your image asset
                  height: 30, // Adjust height
                  width: double.infinity, // Full width
                  fit: BoxFit.cover, // Adjust fit to cover the container
                ),

                Expanded(
                  child: Container(
                    color: Colors.white, // Main screen background color
                    child: TabBarView(
                      controller: _tabController,
                      children: _categories.map((category) {
                        return Center(
                          child: Text(
                            category, // Display category content
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        );
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
                      ? const Color.fromARGB(255, 189, 20, 8)
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
