import 'dart:convert';
import 'package:http/http.dart' as http;

class ConnectionModel {
  final String fromStation;
  final String toStation;
  final String transportMode;
  final int costMin;
  final int costMax;
  final int timeMin;
  final int timeMax;

  ConnectionModel({
    required this.fromStation,
    required this.toStation,
    required this.transportMode,
    required this.costMin,
    required this.costMax,
    required this.timeMin,
    required this.timeMax,
  });

  factory ConnectionModel.fromJson(Map<String, dynamic> json) {
    return ConnectionModel(
      // 👈 تم ربط المتغيرات بالأسماء المرتجعة من الـ RouteStep في الـ Backend
      fromStation: json['fromStation'] ?? '',
      toStation: json['toStation'] ?? '',
      transportMode: json['transportMode'] ?? '',
      costMin: json['costMin'] ?? 0,
      costMax: json['costMax'] ?? 0,
      timeMin: json['timeMin'] ?? 0,
      timeMax: json['timeMax'] ?? 0,
    );
  }
}

class RouteService {
  static const String _baseUrl =
      'https://banhops-backend-production.up.railway.app';

  static Future<List<ConnectionModel>> getRoute({
    required String from,
    required String to,
  }) async {
    // 👈 تم تعديل المسار هنا إلى /api/route/find (بالمفرد) ليتطابق مع الـ Controller بالظبط
    final url = Uri.parse(
      '$_baseUrl/api/routes/find?from=${Uri.encodeComponent(from)}&to=${Uri.encodeComponent(to)}',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // ✅ فك تشفير الـ steps من كائن الـ RouteResult المرتجع
        final List steps = data['steps'] ?? [];
        return steps.map((e) => ConnectionModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error fetching route in service: $e");
    }

    return [];
  }
}