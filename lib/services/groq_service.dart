// lib/services/gemini_service.dart
// ─────────────────────────────────────────────────────────────────
//  Ollama RAG service: searches DB first → asks AI if not found
//  → parses response → picks best route → saves to DB (self-learn)
// ─────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'route_database.dart';

class OllamaService {
  // ── Config ────────────────────────────────────────────────────
  // For Android emulator use 10.0.2.2, for real device use your PC IP
  static const _baseUrl = 'http://10.0.2.2:11434';
  static const _model = 'llama3.2'; // or 'mistral', 'gemma2', etc.
  static const _timeout = Duration(seconds: 60);

  final RouteDatabase _db;
  OllamaService(this._db);

  // ── Main entry: smart query with RAG ─────────────────────────
  Future<ChatResult> smartQuery({
    required String userMessage,
    required List<ChatMessage> history,
    String? from,
    String? to,
  }) async {
    // ── STEP 1: Search local DB ───────────────────────────────
    if (from != null && to != null) {
      final cached = _db.find(from, to);
      if (cached != null) {
        return ChatResult(
          text: _formatCachedRoute(cached),
          source: ResultSource.localDB,
          route: cached,
        );
      }
    }

    // ── STEP 2: Not in DB → Ask Ollama ────────────────────────
    final aiText = await _askOllama(
      userMessage: userMessage,
      history: history,
      from: from,
      to: to,
    );

    // ── STEP 3: Try to parse route from AI response ───────────
    final parsed = _parseRouteFromAI(aiText, from, to);

    // ── STEP 4: Save to DB if valid route found (self-learn) ──
    if (parsed != null) {
      await _db.save(parsed);
    }

    return ChatResult(
      text: aiText,
      source: ResultSource.ollamaAI,
      route: parsed,
      isNewlyLearned: parsed != null,
    );
  }

  // ── Ask Ollama with system prompt ─────────────────────────────
  Future<String> _askOllama({
    required String userMessage,
    required List<ChatMessage> history,
    String? from,
    String? to,
  }) async {
    final systemPrompt = _buildSystemPrompt(from, to);

    final messages = [
      {'role': 'system', 'content': systemPrompt},
      ...history.map((m) => {'role': m.role, 'content': m.content}),
      {'role': 'user', 'content': userMessage},
    ];

    try {
      final response = await http
          .post(
        Uri.parse('$_baseUrl/api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'stream': false,
          'options': {
            'temperature': 0.3, // lower = more accurate/factual
            'num_predict': 800,
          },
        }),
      )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['message']?['content'] as String?) ??
            'حدث خطأ في قراءة الرد';
      }

      return 'خطأ من Ollama: كود ${response.statusCode}';
    } on Exception catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused')) {
        return '⚠️ Ollama مش شغال!\n\n'
            'تأكد إنك شغّلت:\n'
            '• ollama serve\n'
            '• ollama run $_model\n\n'
            'في الـ terminal على جهازك.';
      }
      return '⚠️ خطأ في الاتصال:\n$e';
    }
  }

  // ── System prompt ─────────────────────────────────────────────
  String _buildSystemPrompt(String? from, String? to) => '''
أنت مساعد ذكي متخصص في وسائل المواصلات في مدينة بنها ومحافظة القليوبية، مصر.
لديك معرفة كاملة بالميكروباص والقطارات والتاكسي في المنطقة.
${from != null && to != null ? 'المستخدم يريد التنقل من "$from" إلى "$to".' : ''}

قواعد الرد:
1. أجب دائماً بالعربية بشكل واضح ومختصر
2. عند وصف مسار، رتّب الخطوات بأرقام (① ② ③)
3. اذكر التكلفة التقريبية والوقت
4. إذا في أكثر من خيار، قارن بينهم وقول "الأفضل هو..." مع السبب

إذا وجدت مسار واضح، أضف هذا الـ block في نهاية ردك:
<ROUTE>
from: [نقطة البداية]
to: [الوجهة]
step1_transport: [microbus/train/walk/taxi]
step1_instruction: [الخطوة الأولى]
step2_transport: [اختياري]
step2_instruction: [اختياري]
step3_transport: [اختياري]
step3_instruction: [اختياري]
cost_min: [رقم بالجنيه]
cost_max: [رقم بالجنيه]
duration_min: [دقائق]
duration_max: [دقائق]
score: [0-100 مدى جودة المسار]
score_reason: [سبب الـ score في جملة واحدة]
</ROUTE>
''';

  // ── Parse <ROUTE>...</ROUTE> block ────────────────────────────
  BanHopsRoute? _parseRouteFromAI(
      String text, String? fromHint, String? toHint) {
    final startTag = text.indexOf('<ROUTE>');
    final endTag = text.indexOf('</ROUTE>');
    if (startTag == -1 || endTag == -1) return null;

    final block = text.substring(startTag + 7, endTag).trim();
    final Map<String, String> fields = {};
    for (final line in block.split('\n')) {
      final colon = line.indexOf(':');
      if (colon == -1) continue;
      final key = line.substring(0, colon).trim();
      final val = line.substring(colon + 1).trim();
      if (key.isNotEmpty && val.isNotEmpty) fields[key] = val;
    }

    final from = fields['from'] ?? fromHint ?? '';
    final to = fields['to'] ?? toHint ?? '';
    if (from.isEmpty || to.isEmpty) return null;

    // Build steps
    final steps = <RouteStep>[];
    for (int i = 1; i <= 5; i++) {
      final instruction = fields['step${i}_instruction'];
      final transport = fields['step${i}_transport'] ?? 'microbus';
      if (instruction == null || instruction.isEmpty) break;
      steps.add(RouteStep(
          order: i, instruction: instruction, transport: transport));
    }
    if (steps.isEmpty) return null;

    return BanHopsRoute(
      id: 'learned_${DateTime.now().millisecondsSinceEpoch}',
      from: from,
      to: to,
      steps: steps,
      costMin: int.tryParse(fields['cost_min'] ?? '0') ?? 0,
      costMax: int.tryParse(fields['cost_max'] ?? '0') ?? 0,
      durationMin: int.tryParse(fields['duration_min'] ?? '0') ?? 0,
      durationMax: int.tryParse(fields['duration_max'] ?? '0') ?? 0,
      score: double.tryParse(fields['score'] ?? '0') ?? 0,
      scoreReason: fields['score_reason'] ?? '',
      isLearned: true,
      savedAt: DateTime.now(),
    );
  }

  // ── Format cached route as readable message ───────────────────
  String _formatCachedRoute(BanHopsRoute r) {
    final stepsText = r.steps
        .map((s) => '${_transportEmoji(s.transport)} ${s.instruction}')
        .join('\n');

    return '''
✅ وجدت المسار في قاعدة البيانات!

📍 من: ${r.from}
📍 إلى: ${r.to}

🗺️ خطوات الرحلة:
$stepsText

💰 التكلفة: ${r.costLabel}
⏱️ الوقت: ${r.durationLabel}

⭐ تقييم المسار: ${r.score.toInt()}/100
💡 ${r.scoreReason}

🔄 طُلب هذا المسار ${r.hitCount} ${r.hitCount == 1 ? 'مرة' : 'مرات'}
''';
  }

  String _transportEmoji(String transport) {
    switch (transport) {
      case 'train':
        return '🚂';
      case 'taxi':
        return '🚕';
      case 'walk':
        return '🚶';
      default:
        return '🚌';
    }
  }
}

// ── Data classes ──────────────────────────────────────────────────
enum ResultSource { localDB, ollamaAI }

class ChatMessage {
  final String role; // 'user' | 'assistant'
  final String content;
  const ChatMessage({required this.role, required this.content});
}

class ChatResult {
  final String text;
  final ResultSource source;
  final BanHopsRoute? route;
  final bool isNewlyLearned;

  const ChatResult({
    required this.text,
    required this.source,
    this.route,
    this.isNewlyLearned = false,
  });

  bool get isFromCache => source == ResultSource.localDB;
}