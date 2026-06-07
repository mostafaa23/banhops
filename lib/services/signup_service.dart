import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupService {
  static const String _baseUrl =
      'https://banhops-backend-production.up.railway.app';

  static Future<dynamic> signup({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/api/auth/signup');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "firstName": firstName,
        "lastName": lastName,
        "username": username,
        "email": email,
        "phone": phone,
        "password": password,
      }),
    );

    // طباعة حيوية لمراقبة الحالة في الـ Debug Console
    print("📌 HTTP STATUS CODE: ${response.statusCode}");
    print("📌 SERVER RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return response.body;
      }
    } else {
      String errorMessage = 'Signup Failed';
      try {
        final responseBody = jsonDecode(response.body);
        String rawMessage = responseBody['message'] ?? responseBody['error'] ?? errorMessage;

        // لو الرسالة فيها "interpolatedMessage" نطلع الجزء المهم بس
        if (rawMessage.contains("interpolatedMessage='")) {
          final regex = RegExp(r"interpolatedMessage='([^']+)'");
          final match = regex.firstMatch(rawMessage);
          errorMessage = match?.group(1) ?? errorMessage;
        } else {
          errorMessage = rawMessage;
        }
      } catch (_) {
        // Handle HTML or non-JSON responses
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
