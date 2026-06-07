import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatPersistenceService {
  static const String _baseUrl =
      'https://banhops-backend-production.up.railway.app';

  // ── حفظ رسالة واحدة ──────────────────────────────────────────
  static Future<void> saveMessage({
    required String username,
    required String message,
    required bool isUser,
  }) async {
    final url = Uri.parse('$_baseUrl/api/chat');

    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "message": message,
        "isUser": isUser,
      }),
    );
  }

  // ── جيب كل رسائل اليوزر ──────────────────────────────────────
  static Future<List<Map<String, dynamic>>> getMessages(
      String username) async {
    final url = Uri.parse('$_baseUrl/api/chat/$username');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // ── امسح كل الشات ────────────────────────────────────────────
  static Future<void> clearChat(String username) async {
    final url = Uri.parse('$_baseUrl/api/chat/$username');
    await http.delete(url);
  }
}