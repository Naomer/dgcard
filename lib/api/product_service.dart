import 'package:http/http.dart' as http;

class ProductService {
  final String baseUrl = 'https://alsaifgallery.onrender.com';

  Future<http.Response> get(String endpoint,
      {Map<String, String>? headers, Map<String, String>? queryParams}) async {
    try {
      final uri =
          Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      throw Exception('Error making GET request: $e');
    }
  }
}
