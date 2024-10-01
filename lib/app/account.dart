import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alsaif_gallery/app/login_screen.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool isArabic = false; // Track the language state

  void _toggleLanguage() {
    setState(() {
      isArabic = !isArabic; // Toggle language
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          children: [
            // Shadowed line below the AppBar
            Container(
              height: 1.0,
              color: Colors.grey[300],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  SizedBox(height: 20),
                  // Red 'Login' button
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
                      isArabic
                          ? 'تسجيل الدخول'
                          : 'Login', // Change text based on language
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        text: isArabic
                            ? 'ليس لديك حساب؟ '
                            : "Don't have an account? ",
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: isArabic ? 'سجل الآن' : 'Register now',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    title: Text(isArabic ? 'اللغة' : 'Language'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: _toggleLanguage, // Toggle language
                  ),
                  ListTile(
                    title: Text('Country'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Allow Notifications'),
                    trailing: Switch(
                      value: true,
                      activeColor: Colors.red,
                      inactiveThumbColor: Colors.white,
                      onChanged: (bool value) {},
                    ),
                  ),
                  ListTile(
                    title: Text('Contact Us'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Our Story'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Loyalty Points Policy'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Privacy Policy'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Payment Method'),
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
                      '\n'
                      'Alsaif Gallery © 2024 • All rights reserved.',
                      style: TextStyle(fontSize: 12),
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
