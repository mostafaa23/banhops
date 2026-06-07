import 'dart:convert';
import 'package:http/http.dart' as http;

class TripHistoryService {
  static const String _baseUrl =
      'https://banhops-backend-production.up.railway.app';

  // ── أضف رحلة جديدة ──────────────────────────
  static Future<void> addTrip({
    required String username,
    required String fromLocation,
    required String toLocation,
    required String lineName,
  }) async {
    final url = Uri.parse('$_baseUrl/api/history');

    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "fromLocation": fromLocation,
        "toLocation": toLocation,
        "lineName": lineName,
      }),
    );
  }

  // ── جيب رحلات اليوزر ────────────────────────
  static Future<List<Map<String, dynamic>>> getHistory(String username) async {
    final url = Uri.parse('$_baseUrl/api/history/$username');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // ── امسح كل الرحلات ─────────────────────────
  static Future<void> clearHistory(String username) async {
    final url = Uri.parse('$_baseUrl/api/history/$username');
    await http.delete(url);
  }
}