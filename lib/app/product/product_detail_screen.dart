import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productName;
  final String productImage;

  ProductDetailScreen({required this.productName, required this.productImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: Column(
        children: [
          Image.asset(productImage, width: 200, height: 200),
          const SizedBox(height: 10),
          Text(productName, style: TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Logic to add to cart
            },
            child: Text('Add to Cart'),
          ),
          ElevatedButton(
            onPressed: () {
              // Logic to add to favorites
            },
            child: Text('Add to Favorites'),
          ),
        ],
      ),
    );
  }
}
