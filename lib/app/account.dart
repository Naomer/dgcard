import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alsaif_gallery/app/login_screen.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Shadowed line below the AppBar
          Container(
            height: 1.0,
            color: Colors.grey[300], // Line color
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Shadow color
                    offset: Offset(100, 1000), // Shadow offset
                    blurRadius: 4, // Shadow blur radius
                  ),
                ],
              ),
            ),
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
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Register now',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  title: Text('Language'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {},
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
                      icon:
                          FaIcon(FontAwesomeIcons.twitter, color: Colors.black),
                      onPressed: () {
                        // Add your Twitter link here
                      },
                    ),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.instagram,
                          color: Colors.black),
                      onPressed: () {
                        // Add your Instagram link here
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  '• Shipping and delivery information\n'
                  '• Terms and conditions\n'
                  '• Return policy\n'
                  '• How to buy\n'
                  '• FAQs\n'
                  '• Warranty',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Alsaif Gallery © • All rights reserved.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
