import 'package:alsaif_gallery/screens/About/privacy.dart';
import 'package:alsaif_gallery/screens/login_screen.dart';
import 'package:alsaif_gallery/language_provider.dart';
import 'package:alsaif_gallery/widgets/MainScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset('assets/favlog.png', height: 115),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Directionality(
        textDirection: languageProvider.textDirection,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 1.0,
                color: const Color.fromARGB(255, 212, 212, 212),
              ),
              SizedBox(height: 40),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 185, 38, 28),
                      padding:
                          EdgeInsets.symmetric(vertical: 13, horizontal: 133),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min, // Adjust size to fit content
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          languageProvider.isArabic ? 'دخول' : 'Login',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        SizedBox(width: 5), // Space between text and icon
                        Icon(
                          Icons.login, // Add login icon here
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
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
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 250, 249, 249),
                      borderRadius: BorderRadius.circular(
                          8.0), // Add slight curve to the border
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(languageProvider.isArabic
                              ? 'Change to English'
                              : 'تغير الى العربية'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            languageProvider.toggleLanguage();
                          },
                        ),
                        _buildListTile(
                          title: 'Contact Us',
                          onTap: () {},
                        ),
                        _buildListTile(
                          title: 'Our Story',
                          onTap: () {},
                        ),
                        _buildListTile(
                          title: 'Privacy Policy',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrivacyPage()),
                            );
                          },
                        ),
                        _buildListTile(
                          title: 'Payment Method',
                          onTap: () {},
                        ),
                        // _buildListTile(
                        //   title: 'Feedback',
                        //   onTap: () {},
                        // ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.facebook, color: Colors.black),
                              onPressed: () {},
                            ),
                            SizedBox(width: 46), // Add spacing between icons
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.twitter,
                                  color: Colors.black),
                              onPressed: () {},
                            ),
                            SizedBox(width: 46), // Add spacing between icons
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.instagram,
                                  color: const Color.fromARGB(255, 77, 75, 75)),
                              onPressed: () {},
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
                            '\nDigital Card © 2024 • All rights reserved.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(
      {required String title, required VoidCallback onTap, Widget? leading}) {
    return ListTile(
      leading:
          leading, // This will conditionally display the leading widget (icon)
      title: Text(
        title,
        style: TextStyle(fontSize: 13),
      ),
      trailing: Icon(Icons.arrow_forward_ios), // Keep the arrow icon for others
      onTap: onTap,
    );
  }
}
