import 'package:alsaif_gallery/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../language_provider.dart';

class CountryLanguageSelectionScreen extends StatefulWidget {
  const CountryLanguageSelectionScreen({super.key});

  @override
  _CountryLanguageSelectionScreenState createState() =>
      _CountryLanguageSelectionScreenState();
}

class _CountryLanguageSelectionScreenState
    extends State<CountryLanguageSelectionScreen> {
  String selectedCountry = 'UAE';
  bool isArabicSelected = false;

  final List<Map<String, String>> countries = [
    {'name': 'UAE', 'flag': 'assets/icons/uae_locpin.png'},
    {'name': 'Saudi Arabia', 'flag': 'assets/icons/saudi_locpin.png'},
  ];

  Future<void> _navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenCountryLanguageSelection', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(showSkipButton: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      body: Directionality(
        textDirection: isArabicSelected ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/bgforlang.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Center(
                      child: Image.asset(
                        'assets/icon/alsaiflogf1.png',
                        height: 120,
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      "─────  Country  ──────  البلاد ────",
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                    SizedBox(height: 3),
                    SizedBox(
                      height: 95,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: countries.length,
                        itemBuilder: (context, index) {
                          String countryName = countries[index]['name']!;
                          String flagAsset = countries[index]['flag']!;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCountry = countryName;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: CircleAvatar(
                                backgroundImage: AssetImage(flagAsset),
                                radius: 30,
                                backgroundColor: selectedCountry == countryName
                                    ? Colors.redAccent
                                    : Colors.grey.shade300,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      "─────  Language ──────  اللغة ────",
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isArabicSelected = false;
                              });
                              languageProvider
                                  .setLanguage(false); // Set to English
                              await _navigateToNextScreen();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "English",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(width: 25),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isArabicSelected = true;
                              });
                              languageProvider
                                  .setLanguage(true); // Set to Arabic
                              await _navigateToNextScreen();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "العربية",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
