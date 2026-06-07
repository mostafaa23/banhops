import 'dart:convert';
import 'package:http/http.dart' as http;

class AiChatService {
  static const String _baseUrl =
      "https://banhops-backend-production.up.railway.app";

  static Future<String> sendMessage({
    required String username,
    required String message,
    String? from,
    String? to,
    String? transportMode,
    String? costMin,
    String? costMax,
    String? timeMin,
    String? timeMax,
  }) async {
    final url = Uri.parse("$_baseUrl/api/chat/send");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "message": message,
        if (from != null) "from": from,
        if (to != null) "to": to,
        if (transportMode != null) "transportMode": transportMode,
        if (costMin != null) "costMin": costMin,
        if (costMax != null) "costMax": costMax,
        if (timeMin != null) "timeMin": timeMin,
        if (timeMax != null) "timeMax": timeMax,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["reply"] ?? "";
    }

    throw Exception("AI Error ${response.statusCode}");
  }
}
