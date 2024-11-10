import 'package:alsaif_gallery/screens/product/product_service.dart';
import 'package:flutter/material.dart';

// Products screen to display products by category
class ProductsScreen extends StatelessWidget {
  final String categoryId = "66fd22ba0d369fc5e3ae046a";

  const ProductsScreen(
      {super.key, required String subCategoryId}); // Your category ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ProductService().getProductByCategory(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available.'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text(product['description']),
                  trailing: Text('\$${product['price']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
