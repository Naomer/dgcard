import 'dart:convert';
import 'package:http/http.dart' as http;

// Service to handle product fetching
class ProductService {
  static const String baseUrl = "http://localhost:1010/api/v1/product";

  Future<List<dynamic>> getProductByCategory(String categoryId) async {
    final url = Uri.parse("$baseUrl/getProductByCategories/$categoryId");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON data
        final data = json.decode(response.body);
        if (data['status'] == true) {
          return data['data'];
        } else {
          throw Exception('Failed to load products');
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Error fetching products: $error');
    }
  }
}
