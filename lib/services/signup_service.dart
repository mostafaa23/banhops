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

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Signup Failed: ${response.statusCode} ${response.body}',
      );
    }
  }
}