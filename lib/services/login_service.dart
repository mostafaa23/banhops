import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  static const String _baseUrl =
      'https://banhops-backend-production.up.railway.app';

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/api/auth/login');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    print("LOGIN STATUS: ${response.statusCode}");
    print("LOGIN RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Login failed');
    }
  }
}