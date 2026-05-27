import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl =
      'https://moto-social-api-latest.onrender.com/api';

  // =========================
  // POSTS
  // =========================

  static Future<List<dynamic>> getPosts() async {

    final response = await http.get(
      Uri.parse('$baseUrl/posts'),
    );

    if (response.statusCode == 200) {

      return jsonDecode(response.body);

    } else {

      throw Exception(
        'Error al obtener posts',
      );
    }
  }

  static Future<void> createPost(
    String text,
    File imageFile,
    String username,
  ) async {

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/posts'),
    );

    request.fields['text'] = text;

    request.fields['username'] = username;

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ),
    );

    var response = await request.send();

    if (response.statusCode != 200 &&
        response.statusCode != 201) {

      throw Exception(
        'Error al crear post',
      );
    }
  }

  static Future<void> deletePost(
    int id,
  ) async {

    final response = await http.delete(
      Uri.parse('$baseUrl/posts/$id'),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 204) {

      throw Exception(
        'Error al borrar post',
      );
    }
  }

  static Future<void> likePost(
    int id,
  ) async {

    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id/like'),
    );

    if (response.statusCode != 200) {

      throw Exception(
        'Error al dar like',
      );
    }
  }

  // =========================
  // AUTH
  // =========================

  static Future<void> register(
    String username,
    String password,
  ) async {

    final response = await http.post(

      Uri.parse(
        '$baseUrl/auth/register',
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

    if (response.statusCode != 200 &&
        response.statusCode != 201) {

      throw Exception(
        'Error al registrar usuario',
      );
    }
  }

  static Future<Map<String, dynamic>>
      login(
    String username,
    String password,
  ) async {

    final response = await http.post(

      Uri.parse(
        '$baseUrl/auth/login',
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

      return jsonDecode(
        response.body,
      );

    } else {

      throw Exception(
        'Error al iniciar sesión',
      );
    }
  }
}