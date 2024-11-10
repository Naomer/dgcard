import 'package:flutter/material.dart';
// Import the HomeScreen

class FavoritesScreen extends StatelessWidget {
  // Sample list of favorite items; replace with your actual data source
  final List<String> favoriteItems = [];

  FavoritesScreen({super.key}); // Replace with actual favorites

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
                    offset: Offset(0, 2), // Shadow offset
                    blurRadius: 4, // Shadow blur radius
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: favoriteItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/favo.png', // Replace with your image path
                          height: 240,
                          width: 800,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Choose your favorite products you like now to buy them later whenever you want',
                          style: TextStyle(fontSize: 13, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                                context); // Navigate back to the previous screen
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 167, 15, 4), // Button color
                            padding: EdgeInsets.symmetric(
                                horizontal: 90, vertical: 13),
                            textStyle: TextStyle(
                              fontSize: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.zero, // Remove curved corners
                            ),
                          ),
                          child: Text(
                            'Start Shopping',
                            style: TextStyle(color: Colors.white), // Text color
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: favoriteItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(favoriteItems[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
