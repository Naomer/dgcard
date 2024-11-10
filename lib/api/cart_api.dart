import 'dart:convert';
import 'package:http/http.dart' as http;

class CartApi {
  final String baseUrl =
      'https://alsaifgallery.onrender.com'; // Your backend URL

  Future<void> addProductToCart(String productId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Include token for authentication
      },
      body: json.encode({'productId': productId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add product to cart: ${response.body}');
    }
  }

  Future<void> removeProductFromCart(String productId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cart/remove/$productId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token', // Include token for authentication
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove product from cart: ${response.body}');
    }
  }
}
