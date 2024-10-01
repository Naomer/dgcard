import 'dart:async';
import 'package:alsaif_gallery/country_language%20_selection.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; // Import video_player package
//import 'package:alsaif_gallery/app/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController
      _videoController; // Use late to ensure it's initialized
  Timer? _timer;
  int _splashDuration = 7; // Splash screen duration in seconds

  @override
  void initState() {
    super.initState();

    // Initialize video controller
    _videoController = VideoPlayerController.asset('assets/videos/splash.mp4')
      ..initialize().then((_) {
        setState(() {
          _videoController.play(); // Auto-play the video when initialized
        });
      });

    // Timer to navigate to HomeScreen after the splash duration
    _timer = Timer(Duration(seconds: _splashDuration),
        _navigateToCountryLanguageSelectionScreen);
  }

  // Function to navigate to the HomeScreen
  void _navigateToCountryLanguageSelectionScreen() {
    // if (_videoController.value.isInitialized) {
    //   _videoController.pause(); // Pause the video when navigating
    // }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (_) =>
              CountryLanguageSelectionScreen()), // Navigate to HomeScreen
    );
  }

  // Function to skip the splash screen
  void _skipSplashScreen() {
    if (_timer != null) {
      _timer!.cancel(); // Cancel the timer
    }
    _navigateToCountryLanguageSelectionScreen(); // Navigate to HomeScreen
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when disposing
    _videoController.dispose(); // Dispose the video controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen video player
          Positioned.fill(
            child: _videoController.value.isInitialized
                ? VideoPlayer(_videoController)
                : Center(
                    child:
                        CircularProgressIndicator()), // Show a loader until the video is initialized
          ),
          // Overlay the "Skip" button on top of the video
          Positioned(
            top: 35, // Adjust to position the skip button
            left: 5, // Adjust to position the skip button
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
