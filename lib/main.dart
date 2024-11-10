import 'package:alsaif_gallery/country_language%20_selection.dart';
import 'package:alsaif_gallery/language_provider.dart';
import 'package:alsaif_gallery/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
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
    bool seen = prefs.getBool('seenCountryLanguageSelection') ??
        false; // Provide default value

    if (seen) {
      setState(() {
        _isFirstLaunch = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'Alsaif Gallery',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          locale: languageProvider.locale ??
              Locale('en', ''), // Set default locale if null
          supportedLocales: [
            Locale('en', ''),
            Locale('ar', ''),
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: _isFirstLaunch
              ? CountryLanguageSelectionScreen()
              : SplashScreen(),
        );
      },
    );
  }
}
