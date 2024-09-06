import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:alsaif_gallery/app/favorites_screen.dart';
import 'package:alsaif_gallery/app/account.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Color bColor = Colors.white; // Background color for the body

  // List of icons for navigation items
  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.menu, // Three-dashed row icon for Categories
    Icons.shopping_cart_outlined,
    Icons.local_offer_outlined,
    Icons.account_circle_outlined, // Changed person icon to account circle
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
    const Text('Categories'),
    const Text('Cart'),
    const Text('Offers'),
    Account(), // Use the Account widget here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bColor,
      appBar: AppBar(
        backgroundColor: Colors.white, // Set AppBar background color to white
        elevation:
            _selectedIndex == 0 ? 0 : 0, // Remove shadow for Account screen
        title: _selectedIndex == 4 // Check if the selected index is for Account
            ? Center(
                child: Image.asset(
                  'assets/favlog.png', // Display favlog.png for Account screen
                  height: 120,
                ),
              )
            : Row(
                children: <Widget>[
                  Image.asset(
                    'assets/loggo.png',
                    height: 45,
                  ),
                  SizedBox(width: 0), // Adjust spacing if needed
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              10), // Added padding for better appearance
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'What are you looking for?',
                          hintStyle: TextStyle(
                            fontSize: 13, // Adjust font size for hint text
                            color: const Color.fromARGB(255, 150, 149,
                                149), // Optional: Set hint text color
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(
                              255, 248, 248, 248), // Set fill color to white
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
                  SizedBox(width: 0), // Adjust spacing if needed
                  IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.black, // Set icon color to black
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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: bColor, // Background color behind the curve
        color: const Color.fromARGB(255, 238, 237, 237), // Nav bar color
        buttonBackgroundColor: const Color.fromARGB(
            255, 231, 229, 229), // Floating button background
        height: 70, // Adjusted height for the button size
        animationDuration: Duration(milliseconds: 300), // Smooth animation
        items: _icons.asMap().entries.map((entry) {
          int index = entry.key;
          IconData iconData = entry.value;
          return Container(
            padding:
                EdgeInsets.all(4), // Adjust padding to make the button bigger
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  size: 27, // Icon size remains the same
                  color: _selectedIndex == index
                      ? Colors.red
                      : const Color.fromARGB(
                          255, 80, 80, 80), // Red if selected, grey if not
                ),
                SizedBox(height: 2), // Space between icon and label
                Text(
                  _labels[index], // Labels for the icons
                  style: TextStyle(
                    color: _selectedIndex == index
                        ? const Color.fromARGB(255, 7, 7, 7)
                        : const Color.fromARGB(255, 8, 8, 8),
                    fontSize: 8, // Adjusted font size
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onTap: _onItemTapped, // Handle taps
        index: _selectedIndex, // Current selected index
      ),
    );
  }
}
