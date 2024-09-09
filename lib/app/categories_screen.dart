import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  final List<String> categories = [
    'Cookware',
    'Dinnerware',
    'Kitchen Appliances',
    'Bakeware',
    'Home Décor',
    'Cleaning Supplies',
    'Storage & Organization',
    'Outdoor Cooking',
    'Cutlery & Tools',
    'Lighting',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Uncomment the AppBar if you want to show it.
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   iconTheme: IconThemeData(color: Colors.black), // Back button color
      // ),
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
                    offset: Offset(0, 1), // Shadow offset
                    blurRadius: 4, // Shadow blur radius
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 107, // Adjust width for better visibility
                  color: const Color.fromARGB(255, 248, 247,
                      247), // Background color for the categories list
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(categories[index]),
                        onTap: () {
                          // Handle category selection logic here
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Select a category',
                      style: TextStyle(fontSize: 18),
                    ),
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
