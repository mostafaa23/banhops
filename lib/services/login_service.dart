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
        "username": username.trim(), // ✅ تنظيف اسم المستخدم من أي مسافات زائدة
        "password": password,        // الباسورد يرسل كما هو بدون trim لضمان قبول الرموز والمسافات المقصودة
      }),
    );

    print("LOGIN STATUS: ${response.statusCode}");
    print("LOGIN RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      String errorMessage = 'Login failed';
      try {
        final errorData = jsonDecode(response.body);
        String rawMessage = errorData['message'] ?? errorData['error'] ?? errorMessage;

        if (rawMessage.contains("interpolatedMessage='")) {
          final regex = RegExp(r"interpolatedMessage='([^']+)'");
          final match = regex.firstMatch(rawMessage);
          errorMessage = match?.group(1) ?? errorMessage;
        } else {
          errorMessage = rawMessage;
        }
      } catch (_) {
        if (response.body.contains('<title>')) {
          errorMessage = 'Server Error: ${response.statusCode}';
        } else if (response.body.isNotEmpty) {
          errorMessage = response.body;
        }
      }
      throw Exception(errorMessage);
    }
  }
}