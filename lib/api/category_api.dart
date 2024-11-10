import 'dart:convert';
import 'package:alsaif_gallery/models/category.dart';
import 'package:http/http.dart' as http;

class CategoryApi {
  final String baseUrl = 'https://alsaifgallery.onrender.com';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      final List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((category) => Category.fromJson(category))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
