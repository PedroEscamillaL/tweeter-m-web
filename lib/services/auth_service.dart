import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {

  static const String baseUrl =
      'https://moto-social-api-latest.onrender.com';

  static Future<bool> login(
      String username,
      String password,
      ) async {

    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}