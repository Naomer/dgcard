import 'package:alsaif_gallery/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:alsaif_gallery/app/home_screen.dart'; // Your HomeScreen
import 'package:flutter_localizations/flutter_localizations.dart'; // Localization package
import 'package:alsaif_gallery/localization/applocalizations.dart'; // Custom localizatio; // Import the SplashScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alsaif Gallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SplashScreen(), // Show SplashScreen first
      supportedLocales: [
        Locale('en', ''), // English
        Locale('ar', ''), // Arabic
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // Add your custom localization delegate here
      ],
    );
  }
}
