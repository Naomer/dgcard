import 'package:alsaif_gallery/app/favorites_screen.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final int productCount;

  CartScreen({this.productCount = 0});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<String> favoriteItems =
      []; // Define this list or fetch from a data source

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/loggo.png', // Replace with your logo asset path
              height: 45,
            ),
            SizedBox(width: 12),
            Text(
              'Cart ${widget.productCount} product(s)',
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
            SizedBox(width: 114),
            IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesScreen()),
                ); // Handle favorites icon tap here
              },
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: favoriteItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/nocart.png', // Replace with your image path
                          height: 250,
                          width: 900,
                        ),
                        SizedBox(height: 0),
                        Text(
                          'Your cart is empty! Add your favourite products to it',
                          style: TextStyle(fontSize: 11, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Navigator.pop(
                            //     context); // Navigate back to the previous screen
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 167, 15, 4), // Button color
                            padding: EdgeInsets.symmetric(
                                horizontal: 128, vertical: 13),
                            textStyle: TextStyle(
                              fontSize: 11,
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
