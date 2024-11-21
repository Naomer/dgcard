import 'package:alsaif_gallery/provider/CartProvider.dart';
import 'package:alsaif_gallery/widgets/MainScreen.dart';
import 'package:alsaif_gallery/language_provider.dart';
import 'package:alsaif_gallery/screens/login_screen.dart';
import 'package:alsaif_gallery/splash_screenn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => LanguageProvider(),
//       child: MyApp(),
//     ),
//   );
// }

void main() {
  runApp(
    //ChangeNotifierProvider(
    //create: (_) => CartProvider(),
    // child: ChangeNotifierProvider(
    // create: (_) => LanguageProvider(),
    //create: (BuildContext context) {},
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
        )
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

    // If it's the first launch, show country/language selection, otherwise skip it
    if (_isFirstLaunch) {
      // Set the flag in SharedPreferences so that it doesn't show again
      prefs.setBool('seenCountryLanguageSelection', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'Digital Card',
          // home: ProductDetailScreen(
          //   product: {/* some product data */},
          //   onCompletePurchase: () {},
          // ),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          locale: languageProvider.locale ?? Locale('en', ''),
          supportedLocales: [
            Locale('en', ''),
            Locale('ar', ''),
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // Initial route logic
          // initialRoute: _isFirstLaunch
          //     ? '/splash'
          //     : '/splash', // Only show countryLanguageSelection if first launch
          routes: {
            '/home': (context) => SplashScreen(),
            // '/login': (context) => LoginScreen(),
            // '/main': (context) => MainScreen(),
            // '/countryLanguageSelection': (context) =>
            //     CountryLanguageSelectionScreen(),
          },
        );
      },
    );
  }
}
