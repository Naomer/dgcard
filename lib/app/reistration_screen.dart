import 'package:alsaif_gallery/app/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showButtons = true; // Track whether buttons should be shown
  bool isPhoneRegistration = true; // Track which method is selected

  // Default values
  String _selectedCountryCode = '+966';
  String _selectedPrefix = '50';

  // Options for calling codes
  List<String> _countryCodes = ['+966', '+971', '+965', '+968'];
  List<String> _prefixes966 = [
    '50',
    '51',
    '53',
    '54',
    '55',
    '56',
    '57',
    '58',
    '59'
  ];
  List<String> _prefixes971 = ['50', '52', '54', '55', '56', '58'];
  List<String> _prefixesDefault = []; // No prefixes for +965 and +968

  @override
  void initState() {
    super.initState();
    _updatePrefixList();
  }

  void _updatePrefixList() {
    if (_selectedCountryCode == '+966') {
      _selectedPrefix = '50';
    } else if (_selectedCountryCode == '+971') {
      _selectedPrefix = '50';
    } else {
      _selectedPrefix = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/favlog.png',
          height: 120,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: Column(
          children: [
            Container(
              height: 1.0,
              color: Colors.grey[300],
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Login',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: Divider(color: Colors.grey, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Choose your login method',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(
                          child: Divider(color: Colors.grey, thickness: 1)),
                    ],
                  ),
                  SizedBox(height: 40),
                  showButtons
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildRegistrationButton(
                                Icons.smartphone_outlined, 'Phone Number', () {
                              setState(() {
                                showButtons = false;
                                isPhoneRegistration = true;
                              });
                            }),
                            SizedBox(width: 28),
                            _buildRegistrationButton(
                                Icons.email_outlined, 'E-Mail Address', () {
                              setState(() {
                                showButtons = false;
                                isPhoneRegistration = false;
                              });
                            }),
                          ],
                        )
                      : Column(
                          children: [
                            // Combined toggle with red bar on top
                            Container(
                              height: 30,
                              width: 300,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 187, 20, 8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isPhoneRegistration = true;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isPhoneRegistration
                                              ? Colors.white
                                              : const Color.fromARGB(
                                                  255, 187, 20, 8),
                                          border: Border(
                                            top: BorderSide(
                                              color: const Color.fromARGB(
                                                  255, 187, 20, 8),
                                              width: 4.0,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Phone Number',
                                            style: TextStyle(
                                              color: isPhoneRegistration
                                                  ? const Color.fromARGB(
                                                      255, 187, 20, 8)
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isPhoneRegistration = false;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isPhoneRegistration
                                              ? const Color.fromARGB(
                                                  255, 187, 20, 8)
                                              : Colors.white,
                                          border: Border(
                                            top: BorderSide(
                                              color: const Color.fromARGB(
                                                  255, 187, 20, 8),
                                              width: 4.0,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'E-Mail Address',
                                            style: TextStyle(
                                              color: isPhoneRegistration
                                                  ? Colors.white
                                                  : const Color.fromARGB(
                                                      255, 187, 20, 8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            // Input field based on selected registration method
                            SizedBox(
                              width: 300,
                              height: 47,
                              child: isPhoneRegistration
                                  ? TextField(
                                      decoration: InputDecoration(
                                        prefixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.smartphone,
                                                color: Colors.grey),
                                            SizedBox(width: 8),
                                            DropdownButton<String>(
                                              value: _selectedCountryCode,
                                              items: _countryCodes
                                                  .map((String code) {
                                                return DropdownMenuItem<String>(
                                                  value: code,
                                                  child: Text(code),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _selectedCountryCode =
                                                      newValue!;
                                                  _updatePrefixList();
                                                });
                                              },
                                            ),
                                            SizedBox(width: 8),
                                            DropdownButton<String>(
                                              value: _selectedPrefix.isNotEmpty
                                                  ? _selectedPrefix
                                                  : null,
                                              items: _getPrefixList()
                                                  .map((String prefix) {
                                                return DropdownMenuItem<String>(
                                                  value: prefix,
                                                  child: Text(prefix),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _selectedPrefix = newValue!;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        labelText: 'Phone Number',
                                        labelStyle: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 128, 127, 127)),
                                        filled: true,
                                        fillColor: const Color.fromARGB(
                                            255, 248, 246, 246),
                                        border: InputBorder.none,
                                      ),
                                      keyboardType: TextInputType.phone,
                                    )
                                  : TextField(
                                      decoration: InputDecoration(
                                        labelText: 'E-Mail Address',
                                        labelStyle: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 128, 127, 127)),
                                        filled: true,
                                        fillColor: const Color.fromARGB(
                                            255, 248, 246, 246),
                                        border: InputBorder.none,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                            ),
                            SizedBox(height: 13),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 199, 18, 5),
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 109),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              onPressed: () {
                                // Handle registration here
                              },
                              child: Text(
                                'Register now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                          child: Divider(color: Colors.grey, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('OR', style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(
                          child: Divider(color: Colors.grey, thickness: 1)),
                    ],
                  ),
                  SizedBox(height: 35),
                  SizedBox(
                    width: double.infinity, // Full width for the button
                    height: 48, // Custom height for the button
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 243, 61, 16), // Red background color
                        padding: EdgeInsets.symmetric(
                            vertical: 0), // No extra padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Straight edges
                        ),
                      ),
                      onPressed: () {
                        // Google login functionality here
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.white, // Set Google icon color to white
                        size: 24, // Increase icon size
                      ),
                      label: Text(
                        'LOGIN WITH GOOGLE',
                        style: TextStyle(
                          color: Colors.white, // Set text color to white
                          fontSize: 16,
                          fontWeight: FontWeight.normal, // Unbolded text
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: 'LOGIN',
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getPrefixList() {
    if (_selectedCountryCode == '+966') {
      return _prefixes966;
    } else if (_selectedCountryCode == '+971') {
      return _prefixes971;
    } else {
      return _prefixesDefault;
    }
  }

  Widget _buildRegistrationButton(
      IconData icon, String text, VoidCallback onPressed) {
    return SizedBox(
      width: 137,
      height: 107,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 187, 20, 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 37),
            SizedBox(height: 15),
            Text(text, style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
