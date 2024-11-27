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
              'Digital Card',
              style: TextStyle(
                fontSize: 25,
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
        color: const Color.fromARGB(255, 243, 241, 241),
        buttonBackgroundColor: const Color.fromARGB(255, 243, 241, 241),
        height: 71,
        animationDuration: const Duration(milliseconds: 300),
        index: _selectedIndex,
        items: [
          _buildNavItem(Icons.home_outlined, "Home", 0),
          _buildNavItem(Icons.format_list_bulleted, "Categories", 1),
          _buildCartNavItem(),
          _buildNavItem(Icons.local_offer_outlined, "Offers", 3),
          _buildNavItem(
            _isLoggedIn ? Icons.person_outline : Icons.account_circle_outlined,
            _isLoggedIn ? "Profile" : "Account",
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 23,
          color: isSelected
              ? const Color.fromARGB(255, 159, 64, 58)
              : const Color.fromARGB(255, 69, 69, 69),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color.fromARGB(255, 159, 64, 58)
                : const Color.fromARGB(255, 131, 128, 128),
            fontSize: 8,
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
                      ? const Color.fromARGB(255, 159, 64, 58)
                      : const Color.fromARGB(255, 69, 69, 69),
                ),
                if (cartItemCount > 0)
                  Positioned(
                    top: -5,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 192, 58, 48),
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
            const SizedBox(height: 3),
            Text(
              "Cart",
              style: TextStyle(
                color: isSelected
                    ? const Color.fromARGB(255, 159, 64, 58)
                    : const Color.fromARGB(255, 131, 128, 128),
                fontSize: 8,
              ),
            ),
          ],
        ),
      ],
    );
  }
}




  // PreferredSizeWidget? _buildAppBar() {
  //   if (_selectedIndex == 0 || _selectedIndex == 1 || _selectedIndex == 3) {
  //     return AppBar(
  //       backgroundColor: Colors.white,
  //       title: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Image.asset(
  //             'assets/loggo.png',
  //             height: 33,
  //           ),
  //           Expanded(
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 2.0),
  //               child: GestureDetector(
  //                 onTap: () {
  //                   // Navigate to the search screen when the search box is tapped
  //                   Navigator.push(
  //                     context,
  //                     PageRouteBuilder(
  //                       pageBuilder: (context, animation, secondaryAnimation) =>
  //                           SearchScreen(),
  //                       transitionsBuilder:
  //                           (context, animation, secondaryAnimation, child) {
  //                         return FadeTransition(
  //                             opacity: animation, child: child);
  //                       },
  //                     ),
  //                   );
  //                 },
  //                 child: SizedBox(
  //                   height: 35.0,
  //                   child: TextField(
  //                     enabled:
  //                         false, // Disable editing, only for tapping to navigate
  //                     decoration: InputDecoration(
  //                       hintText: 'Find it here...',
  //                       hintStyle: TextStyle(
  //                         fontSize: 13.0,
  //                         color: Colors.grey[600],
  //                       ),
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(4.0),
  //                         borderSide: BorderSide.none,
  //                       ),
  //                       filled: true,
  //                       fillColor: Colors.grey[200],
  //                       contentPadding: const EdgeInsets.symmetric(
  //                         vertical: 16.0,
  //                         horizontal: 14.0,
  //                       ),
  //                       suffixIcon: Icon(
  //                         Icons.search,
  //                         color: Colors.grey[600],
  //                         size: 20.0,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           IconButton(
  //             icon: const Icon(Icons.favorite_border, color: Colors.black),
  //             onPressed: () {
  //               Navigator.of(context).push(
  //                 MaterialPageRoute(
  //                   builder: (context) => FavoritesScreen(favoriteProducts: []),
  //                 ),
  //               );
  //             },
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //   return null;
  // }