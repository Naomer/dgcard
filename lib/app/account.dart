import 'package:alsaif_gallery/app/login_screen.dart';
import 'package:alsaif_gallery/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor:
          Colors.white, // Set the background color of the whole page to white
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 199, 18, 5),
                      padding: EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      languageProvider.isArabic ? 'دخول' : 'Login',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
                  SizedBox(height: 20),

                  // Applying gray background for the selected ListTiles and Row
                  Container(
                    color: const Color.fromARGB(
                        255, 250, 249, 249), // Set the gray background color
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(languageProvider.isArabic
                              ? 'Change to English'
                              : 'تغيير الى العربية'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            languageProvider
                                .toggleLanguage(); // Toggle language globally
                          },
                        ),
                        ListTile(
                          title: Text(
                              languageProvider.isArabic ? 'الدولة' : 'Country'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text(languageProvider.isArabic
                              ? 'الإخطارات تسمح'
                              : 'Allow Notifications'),
                          trailing: Switch(
                            value: true,
                            activeColor: Colors.red,
                            inactiveThumbColor: Colors.white,
                            onChanged: (bool value) {},
                          ),
                        ),
                        ListTile(
                          title: Text(languageProvider.isArabic
                              ? 'تواصل معنا'
                              : 'Contact Us'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text(languageProvider.isArabic
                              ? 'عن السيف غاليري'
                              : 'Our Story'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text(languageProvider.isArabic
                              ? 'سياسة نقاط الولاء'
                              : 'Loyalty Points Policy'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text(languageProvider.isArabic
                              ? 'سياسة الخصوصية'
                              : 'Privacy Policy'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text(languageProvider.isArabic
                              ? 'استفسارات الدفع'
                              : 'Payment Method'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.facebook, color: Colors.black),
                              onPressed: () {
                                // Add your Facebook link here
                              },
                            ),
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.twitter,
                                  color: Colors.black),
                              onPressed: () {
                                // Add your Twitter link here
                              },
                            ),
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.instagram,
                                  color: const Color.fromARGB(255, 77, 75, 75)),
                              onPressed: () {
                                // Add your Instagram link here
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
