import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupService {
  static Future<dynamic> signup({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
  }) async {
    final url = Uri.parse(
      'https://eliminate-lapel-scaling.ngrok-free.dev/api/auth/signup',
    );

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      },
      body: jsonEncode({
        "firstName": firstName,
        "lastName": lastName,
        "username": username,
        "password": password,
      }),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE: ${response.body}");

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Signup Failed: ${response.statusCode} ${response.body}',
      );
    }
  }
}