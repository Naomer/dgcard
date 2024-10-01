import 'package:alsaif_gallery/app/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:alsaif_gallery/permission.dart';

class SomePage extends StatelessWidget {
  final PermissionService _permissionService = PermissionService();

  @override
  Widget build(BuildContext context) {
    // Call this when you need to ask for permissions
    _permissionService.requestAllPermissions();

    return Scaffold(
        // Your page content here
        );
  }
}

class CountryLanguageSelectionScreen extends StatefulWidget {
  @override
  _CountryLanguageSelectionScreenState createState() =>
      _CountryLanguageSelectionScreenState();
}

class _CountryLanguageSelectionScreenState
    extends State<CountryLanguageSelectionScreen> {
  String selectedCountry = 'UAE'; // Default selected country

  // List of countries and their flags
  final List<Map<String, String>> countries = [
    {
      'name': 'UAE',
      'flag': 'assets/icons/uae_locpin.png',
    },
    {
      'name': 'Saudi Arabia',
      'flag': 'assets/icons/saudi_locpin.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add a background image instead of a plain color
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/icons/bgforlang.png'), // Set your background image here
            fit: BoxFit.cover, // Cover the whole screen
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 220),
              // Country selection
              Text(
                "─────  Country  ──────  البلاد ────",
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
              SizedBox(height: 3),
              Container(
                height: 95,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    String countryName = countries[index]['name']!;
                    String flagAsset = countries[index]['flag']!;
                    bool isSelected = selectedCountry == countryName;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCountry = countryName;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Makes it circular
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Move the location pins to the right side
                            Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.location_on,
                                size: 125,
                                color: isSelected
                                    ? Colors.redAccent
                                    : Colors.grey.shade300,
                              ),
                            ),
                            // Customize the flag size and positioning
                            Positioned(
                              child: CircleAvatar(
                                backgroundImage: AssetImage(flagAsset),
                                radius: 30, // Customize the flag circle size
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Language selection
              SizedBox(height: 40),
              Text(
                "─────  Language ──────  اللغة ────",
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
              SizedBox(height: 20),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // English Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          // Logic to select language (if any)
                        });

                        // Call the permission handling logic from PermissionService
                        await PermissionService().requestAllPermissions();

                        // Navigate to HomeScreen after permissions are handled
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen()), // Navigate to HomeScreen
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Custom curve
                        ),
                      ),
                      child: Text(
                        "English",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: 25),
                  // Arabic Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          // Logic to select language (if any)
                        });

                        // Call the permission handling logic from PermissionService
                        await PermissionService().requestAllPermissions();

                        // Navigate to HomeScreen after permissions are handled
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen()), // Navigate to HomeScreen
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Custom curve
                        ),
                      ),
                      child: Text(
                        "العربية",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
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
}
