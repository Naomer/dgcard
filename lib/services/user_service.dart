import 'dart:convert';
import 'package:alsaif_gallery/api/api_service.dart';
import 'package:alsaif_gallery/models/user.dart';

class UserService extends ApiService {
  Future<User> registerUser(
      String firstName,
      String lastName,
      String userName,
      String password,
      String email,
      String mobile,
      String country,
      String userType) async {
    final response = await post(
      '/user/register',
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'userName': userName,
        'password': password,
        'email': email,
        'mobile': mobile,
        'country': country,
        'userType': userType,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body)['user']);
    } else {
      throw Exception('Failed to register user: ${response.body}');
    }
  }

  Future<String> signInUser(String email, String password) async {
    final response = await post(
      'https://alsaifgallery.onrender.com/api/v1/user/signIn',
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data']['token'];
    } else {
      throw Exception('Failed to sign in: ${response.body}');
    }
  }

  Future<User> getUserInfo(String token) async {
    final response = await get(
        'https://alsaifgallery.onrender.com/api/v1/user/getUser Info',
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to fetch user info: ${response.body}');
    }
  }

  Future<void> sendForgetPasswordCode(String email) async {
    final response = await post(
      'https://alsaifgallery.onrender.com/api/v1/user/sendForgetPasswordCode',
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send forget password code: ${response.body}');
    }
  }

  Future<void> recoverPassword(
      String email, String code, String newPassword) async {
    final response = await post(
      'https://alsaifgallery.onrender.com/api/v1/user/recoverPassword',
      body: jsonEncode({'email': email, 'code': code, 'password': newPassword}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to recover password: ${response.body}');
    }
  }

  static signIn(String s, String text) {}

  static register(String text, String text2, String text3, String text4,
      String text5, String text6, String text7, String text8) {}
}
