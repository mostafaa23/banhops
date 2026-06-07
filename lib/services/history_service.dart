import 'dart:convert';
import 'package:http/http.dart' as http;

class HistoryService {

  static const String _baseUrl =
      'https://banhops-backend-production.up.railway.app';

  static Future<List<dynamic>> fetchHistory(String username) async {

    final url = Uri.parse(
      '$_baseUrl/api/history/$username',
    );

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );

    print("HISTORY STATUS: ${response.statusCode}");
    print("HISTORY RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'Failed: ${response.statusCode}',
    );
  }
}