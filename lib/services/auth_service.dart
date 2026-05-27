import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  static const String baseUrl =
      'https://moto-social-api-latest.onrender.com';

  static Future<bool> login(
    String username,
    String password,
  ) async {

    final response = await http.post(

      Uri.parse(
        '$baseUrl/api/auth/login',
      ),

      headers: {
        'Content-Type':
            'application/json',
      },

      body: jsonEncode({

        'username': username,
        'password': password,

      }),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(
        response.body,
      );

      final prefs =
          await SharedPreferences
              .getInstance();

      await prefs.setString(
        'token',
        data['token'],
      );

      await prefs.setString(
        'username',
        username,
      );

      return true;
    }

    return false;
  }
}