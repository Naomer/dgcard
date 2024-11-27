import 'package:http/http.dart' as http;

class HomeApiService {
  final String baseUrl = 'https://alsaifgallery.onrender.com';

  Future<http.Response> get(String endpoint,
      {Map<String, String>? headers}) async {
    return await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
  }

  Future<http.Response> post(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers ?? {'Content-Type': 'application/json'},
      body: body,
    );
  }
}
