import 'dart:convert';
import 'package:http/http.dart' as http;

class FavoritesApi {
  final String baseUrl =
      'https://alsaifgallery.onrender.com'; // Your backend URL

  Future<void> addProductToFavorites(String productId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/favorites/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Include token for authentication
      },
      body: json.encode({'productId': productId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add product to favorites: ${response.body}');
    }
  }

  Future<void> removeProductFromFavorites(
      String productId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/favorites/remove/$productId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token', // Include token for authentication
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to remove product from favorites: ${response.body}');
    }
  }
}
