import 'dart:convert';
import 'package:http/http.dart' as http;

class HistoryService {

  static Future<List<dynamic>> fetchHistory() async {

    final url = Uri.parse(
      'https://eliminate-lapel-scaling.ngrok-free.dev/api/history/mahmoud_2026',
    );

    final response = await http.get(
      url,
      headers: {
        "ngrok-skip-browser-warning": "true",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'Failed: ${response.statusCode}',
    );
  }
}