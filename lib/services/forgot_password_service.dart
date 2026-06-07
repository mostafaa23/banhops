import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  static const String _baseUrl =
      'https://banhops-backend-production.up.railway.app';

  static Future<String> recoverPassword({
    required String username,
    required String email,
  }) async {
    final url = Uri.parse('$_baseUrl/api/auth/forgot-password');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "email":    email,
      }),
    );

    try {
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        return data['password'];
      }

      String rawMessage = data['message'] ?? data['error'] ?? 'Failed to recover password';
      String errorMessage;

      if (rawMessage.contains("interpolatedMessage='")) {
        final regex = RegExp(r"interpolatedMessage='([^']+)'");
        final match = regex.firstMatch(rawMessage);
        errorMessage = match?.group(1) ?? rawMessage;
      } else {
        errorMessage = rawMessage;
      }
      throw Exception(errorMessage);
    } catch (e) {
      if (e is Exception && !e.toString().contains('FormatException')) {
        rethrow;
      }
      
      String errorMessage = 'Failed to recover password';
      if (response.body.contains('<title>')) {
        errorMessage = 'Server Error: ${response.statusCode}';
      } else if (response.body.isNotEmpty) {
        errorMessage = response.body;
      }
      throw Exception(errorMessage);
    }
  }
}