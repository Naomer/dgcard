import 'package:alsaif_gallery/provider/CartProvider.dart';
import 'package:alsaif_gallery/screens/SearchScreen.dart';
import 'package:alsaif_gallery/screens/favorites_screen.dart';
import 'package:alsaif_gallery/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:alsaif_gallery/screens/account.dart';
import 'package:alsaif_gallery/screens/cartscreen.dart';
import 'package:alsaif_gallery/screens/category_screen.dart';
import 'package:alsaif_gallery/screens/home_screen.dart';
import 'package:alsaif_gallery/screens/product_list_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   'assets/loggo.png',
            //   height: 100,
            //   width: 100,
            // ),
            // SizedBox(height: 20),
            Text(
              'DIGITAL CARD',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),
            SpinKitWave(
              color: Colors.black,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false;

  // Define GlobalKeys for each screen's Navigator
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // Define the list of screens
  final List<Widget> _screens = [
    HomeScreen(),
    CategoryScreen(onProductSelected: (product) {}),
    CartScreen(cart: [], onStartShoppingPressed: () {}),
    ProductListScreen(),
    Account(), // Initially Account, will switch to Profile when logged in
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  // Check login state when the app starts
  Future<void> _checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  // Handle bottom navigation bar tab selection
  void _onTabSelected(int index) {
    if (_selectedIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update the list of screens based on the login state
    _screens[4] = _isLoggedIn ? ProfileScreen() : Account();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: List.generate(
          _screens.length,
          (index) => Offstage(
            offstage: _selectedIndex != index,
            child: Navigator(
              key: _navigatorKeys[index],
              onGenerateRoute: (routeSettings) =>
                  MaterialPageRoute(builder: (context) => _screens[index]),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(255, 251, 251, 251),
        color: const Color.fromARGB(255, 236, 236, 236),
        buttonBackgroundColor: const Color.fromARGB(255, 236, 236, 236),
        height: 75,
        animationDuration: const Duration(milliseconds: 300),
        index: _selectedIndex,
        items: [
          _buildNavItem(Icons.home_filled, "   Home   ", 0),
          _buildNavItem(Icons.format_list_bulleted, " Categories ", 1),
          _buildCartNavItem(),
          _buildNavItem(Icons.local_offer_outlined, "   Offers   ", 3),
          _buildNavItem(
            _isLoggedIn
                ? Icons.account_circle_sharp
                : Icons.account_circle_outlined,
            _isLoggedIn ? "   Account   " : "   Account   ",
            4,
          ),
        ],
        onTap: _onTabSelected,
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  // Custom widget for creating bottom nav items
  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;

    // Use a larger size only for the Home icon (index 0)
    final iconSize = index == 0
        ? 25.0 // Larger size for Home (index 0)
        : index == 1
            ? 26.0 // Slightly smaller size for Categories (index 1)
            : 25.0; //

    final spacing = index == 1 ? 5.0 : 4.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: isSelected
              ? const Color.fromARGB(255, 179, 37, 27)
              : const Color.fromARGB(255, 69, 69, 69),
        ),
        SizedBox(height: spacing),
        Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color.fromARGB(255, 196, 53, 43)
                : const Color.fromARGB(255, 109, 109, 109),
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  // Custom widget for Cart navigation item
  Widget _buildCartNavItem() {
    final cartItemCount = 0; // Replace with actual cart item count
    final isSelected = _selectedIndex == 2;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 26,
                  color: isSelected
                      ? const Color.fromARGB(255, 196, 58, 49)
                      : const Color.fromARGB(255, 69, 69, 69),
                ),
                if (cartItemCount > 0)
                  Positioned(
                    top: -5,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 197, 43, 32),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$cartItemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "    Cart     ",
              style: TextStyle(
                color: isSelected
                    ? const Color.fromARGB(255, 175, 43, 34)
                    : const Color.fromARGB(255, 83, 83, 83),
                fontSize: 9,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
