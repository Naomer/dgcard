import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider for state management
import 'package:flutter_localizations/flutter_localizations.dart';
import 'language_provider.dart'; // This is a new file for language management
import 'splash_screen.dart'; // Import your SplashScreen here

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Accessing the language provider to get the locale
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'Alsaif Gallery',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          locale: languageProvider.locale, // Dynamically update the locale
          supportedLocales: [
            Locale('en', ''), // English
            Locale('ar', ''), // Arabic
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: SplashScreen(), // First screen of your app
        );
      },
    );
  }
}
