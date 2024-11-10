import 'dart:async';
import 'package:alsaif_gallery/country_language%20_selection.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  final int _splashDuration = 7; // Splash screen duration in seconds

  @override
  void initState() {
    super.initState();

    // Start the timer to navigate after the splash duration
    _timer = Timer(Duration(seconds: _splashDuration), _navigateToNextScreen);
  }

  // Function to navigate to the next screen
  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => CountryLanguageSelectionScreen(),
      ),
    );
  }

  // Function to skip the splash screen
  void _skipSplashScreen() {
    if (_timer != null) {
      _timer!.cancel(); // Cancel the timer
    }
    _navigateToNextScreen(); // Navigate to the next screen
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen image as the splash screen
          Positioned.fill(
            child: Image.asset(
              'assets/icons/bgforlang.png', // Ensure this path is correct
              fit: BoxFit.cover, // Cover the entire screen
            ),
          ),
          // Overlay the "Skip" button on top of the image
          Positioned(
            top: 35,
            right: 10,
            child: GestureDetector(
              onTap: _skipSplashScreen, // Skip the splash screen
              child: Container(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Skip",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white, // White text for contrast
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
