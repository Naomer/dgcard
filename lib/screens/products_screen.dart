import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductScreen extends StatefulWidget {
  final String categoryId;

  const ProductScreen({super.key, required this.categoryId});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:1010/api/v1/product/getProductsByCategory/${widget.categoryId}'), // Adjust the endpoint according to your API
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        products = data['data']; // Update based on your response structure
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    leading: Image.network(
                        products[index]['productImage']['data'],
                        fit: BoxFit
                            .cover), // Adjust based on your product data structure
                    title: Text(products[index]['productName']),
                    subtitle: Text(
                        'Price: \$${products[index]['price']}'), // Adjust according to your data
                    onTap: () {
                      // Navigate to product detail page
                    },
                  ),
                );
              },
            ),
    );
  }
}
