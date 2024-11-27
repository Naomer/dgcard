import 'package:alsaif_gallery/provider/CartProvider.dart';
import 'package:alsaif_gallery/widgets/MainScreen.dart';
import 'package:alsaif_gallery/language_provider.dart';
import 'package:alsaif_gallery/screens/login_screen.dart';
import 'package:alsaif_gallery/screens/account.dart'; // New import
import 'package:alsaif_gallery/screens/profile_screen.dart'; // New import
import 'package:alsaif_gallery/splash_screenn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('seenCountryLanguageSelection') ?? false;

    setState(() {
      _isFirstLaunch = !seen;
    });

    // Set the flag in SharedPreferences so it doesn't show again
    if (_isFirstLaunch) {
      prefs.setBool('seenCountryLanguageSelection', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'Digital Card',
          debugShowCheckedModeBanner: false,
          home: SplashScreen(), // Use AuthCheck to handle login state
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          locale: languageProvider.locale ?? const Locale('en', ''),
          supportedLocales: const [
            Locale('en', ''),
            Locale('ar', ''),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routes: {
            '/home': (context) => SplashScreen(),
            '/login': (context) => LoginScreen(),
            '/profile': (context) => ProfileScreen(),
            '/account': (context) => Account(),
          },
        );
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data!) {
          return ProfileScreen(); // User is logged in
        } else {
          return Account(); // User is not logged in
        }
      },
    );
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // Default to false
  }
}
