import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPhoneSelected = true;
  bool isEmailSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/favlog.png',
          height: 120,
        ),
        centerTitle: true,
      ),
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
          SizedBox(height: 16),
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
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Choose your login method',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isPhoneSelected = true;
                          isEmailSelected = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isPhoneSelected ? Colors.red : Colors.white,
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        child: Column(
                          children: [
                            Icon(
                              Icons.phone,
                              color: isPhoneSelected
                                  ? Colors.white
                                  : const Color.fromARGB(255, 156, 20, 10),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Phone Number',
                              style: TextStyle(
                                color: isPhoneSelected
                                    ? Colors.white
                                    : const Color.fromARGB(255, 151, 18, 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isPhoneSelected = false;
                          isEmailSelected = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: !isPhoneSelected
                              ? const Color.fromARGB(255, 182, 25, 14)
                              : Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 170, 18, 7)),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        child: Column(
                          children: [
                            Icon(
                              Icons.email,
                              color:
                                  !isPhoneSelected ? Colors.white : Colors.red,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'E-mail Address',
                              style: TextStyle(
                                color: !isPhoneSelected
                                    ? Colors.white
                                    : const Color.fromARGB(255, 168, 16, 5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                isPhoneSelected
                    ? Column(
                        children: [
                          Row(
                            children: [
                              DropdownButton<String>(
                                value: '+966',
                                items: <String>['+966', '+971', '+965', '+968']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {},
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    hintText: 'Phone Number',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'We\'ll text you a code',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'E-mail Address',
                              hintText: 'E-mail Address',
                            ),
                          ),
                          SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'We\'ll text you a code',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'OR',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 219, 36, 4), // Red background color
                    padding: EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Straight edges
                    ),
                    minimumSize: Size(double.infinity,
                        44), // Make button full width and adjust height
                  ),
                  onPressed: () {
                    // Google login functionality here
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.white, // Set Google icon color to white
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
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    // Navigate to the registration screen
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'REGISTER NOW',
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ), // Add login options here
              ],
            ),
          ),
        ],
      ),
    );
  }
}
