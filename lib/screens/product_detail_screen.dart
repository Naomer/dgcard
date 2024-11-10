import 'package:alsaif_gallery/models/product.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        // Make the body scrollable
        child: Column(
          children: [
            Image.network(product.imageUrl),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.name,
                style: TextStyle(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '\$${product.price.toStringAsFixed(2)}', // Display price with two decimal points
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.description ??
                    'No description available', // Handle null description
                style: TextStyle(fontSize: 16),
                textAlign:
                    TextAlign.center, // Center align the description text
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add product to cart logic here
                // For example: Cart.addProduct(product);
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
