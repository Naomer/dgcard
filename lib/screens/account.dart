import 'package:alsaif_gallery/screens/login_screen.dart';
import 'package:alsaif_gallery/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool isLoggedIn = false; // Track login status
  String firstName = '';
  String lastName = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check login status when the screen opens
  }

  // Check if the user is logged in and retrieve user data
  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool loggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (loggedIn) {
      setState(() {
        isLoggedIn = true;
        firstName = prefs.getString('firstName') ?? 'User';
        lastName = prefs.getString('lastName') ?? '';
      });
    }
  }

  // Logout function to clear user data and login status
  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('firstName');
    await prefs.remove('lastName');

    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: languageProvider.textDirection,
        child: Column(
          children: [
            Container(
              height: 1.0,
              color: Colors.grey[300],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  SizedBox(height: 20),
                  // Display different content based on whether the user is logged in
                  isLoggedIn
                      ? Column(
                          children: [
                            Text(
                              'Welcome $firstName $lastName',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                // Navigate to edit user info (e.g., a settings screen)
                              },
                              child: Text(
                                languageProvider.isArabic
                                    ? 'الإعدادات'
                                    : 'Settings',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 199, 18, 5),
                                padding: EdgeInsets.symmetric(
                                    vertical: 11, horizontal: 140),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              child: Text(
                                languageProvider.isArabic ? 'دخول' : 'Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: RichText(
                                text: TextSpan(
                                  text: languageProvider.isArabic
                                      ? 'ليس لديك حساب؟ '
                                      : "Don't have an account? ",
                                  style: TextStyle(color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: languageProvider.isArabic
                                          ? 'سجل الآن'
                                          : 'Register now',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                  // Gray section for various settings and links
                  SizedBox(height: 20),
                  Container(
                    color: const Color.fromARGB(255, 250, 249, 249),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(languageProvider.isArabic
                              ? 'Change to English'
                              : 'تغيير الى العربية'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            languageProvider.toggleLanguage();
                          },
                        ),
                        // Additional ListTile options go here...
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.facebook, color: Colors.black),
                              onPressed: () {
                                // Facebook link
                              },
                            ),
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.twitter,
                                  color: Colors.black),
                              onPressed: () {
                                // Twitter link
                              },
                            ),
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.instagram,
                                  color: const Color.fromARGB(255, 77, 75, 75)),
                              onPressed: () {
                                // Instagram link
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        Text(
                          '• Shipping and delivery information     '
                          '• How to buy\n'
                          '\n'
                          '• Terms and conditions                          '
                          '• FAQs\n'
                          '\n'
                          '• Return policy'
                          '• Warranty',
                          style: TextStyle(fontSize: 11),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            '\nAlsaif Gallery © 2024 • All rights reserved.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Logout button at the bottom
            if (isLoggedIn)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: GestureDetector(
                  onTap: _logout,
                  child: Text(
                    languageProvider.isArabic ? 'تسجيل الخروج' : 'Logout',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 163, 25, 15),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
