import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/ai_chat_service.dart';
import '../services/chat_persistence_service.dart';
import '../services/user_session.dart';

class ChatUiMessage {
  final int id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatUiMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class SmartChatScreen extends StatefulWidget {
  final ValueChanged<NavTab> onNavigate;
  final String? from;
  final String? to;
  final String? transportMode;
  final String? costMin;
  final String? costMax;
  final String? timeMin;
  final String? timeMax;

  const SmartChatScreen({
    super.key,
    required this.onNavigate,
    this.from,
    this.to,
    this.transportMode,
    this.costMin,
    this.costMax,
    this.timeMin,
    this.timeMax,
  });

  @override
  State<SmartChatScreen> createState() => _SmartChatScreenState();
}

class _SmartChatScreenState extends State<SmartChatScreen> {
  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<ChatUiMessage> _messages = [];
  bool _isTyping = false;
  bool _isIntroAdded = false;
  bool _hasText = false;
  String _username = 'guest';

  @override
  void initState() {
    super.initState();
    _initUser();

    _ctrl.addListener(() {
      final has = _ctrl.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  Future<void> _initUser() async {
    _username = await UserSession.getUsername();
    // 1. ننتظر أولاً حتى يتم تحميل التاريخ بالكامل من قاعدة البيانات لضمان النزول لآخر رسالة
    await _loadChatHistory();

    // 2. التحقق الذكي: إذا كان الشات فارغاً (أو يحتوي فقط على رسالة الترحيب الأولى)
    if (_messages.length <= 1) {
      if (widget.from != null &&
          widget.to != null &&
          widget.transportMode != null) {

        _send(
            '''
اشرح لي الرحلة التي اخترتها.

من:
${widget.from}

إلى:
${widget.to}

وسيلة النقل:
${widget.transportMode}

التكلفة:
${widget.costMin}-${widget.costMax}

الوقت:
${widget.timeMin}-${widget.timeMax}
'''
        );
      }
    }
  }

  Future<void> _loadChatHistory() async {
    try {
      final data = await ChatPersistenceService.getMessages(_username);
      if (data.isEmpty) {
        _scrollToBottom();
        return;
      }

      final loaded = data.map((m) => ChatUiMessage(
        id: _messages.length + 1,
        text: m['message'] ?? '',
        isUser: m['isUser'] == true,
        timestamp: DateTime.tryParse(m['createdAt'] ?? '') ?? DateTime.now(),
      )).toList();

      if (!mounted) return;
      setState(() {
        _messages.addAll(loaded);
      });

      // النزول لآخر رسالة مبعوثة مباشرة فور اكتمال تحميل الشات عند الدخول للشاشة
      _scrollToBottom();
    } catch (_) {
      // Fail-safe if API is offline
    }
  }

  // دالة تصفير الشات من واجهة المستخدم فقط لتنظيف الشاشة دون مسح الـ Database
  void _confirmClearChat() async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          l10n.clearHistory,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        content: const Text('Are you sure you want to clear the screen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.clear,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (ok == true) {
      if (!mounted) return;

      // ✅ تعديل هنا: تم إزالة استدعاء دالة الـ Service تماماً بناءً على طلبك
      // تصفير واجهة الشات فقط أمام اليوزر وإعادة بناء الرسالة الترحيبية من جديد
      setState(() {
        _messages.clear();
        _isIntroAdded = false;
      });

      _addIntroMessage();
    }
  }

  void _addIntroMessage() {
    if (_isIntroAdded) return;
    final l10n = AppLocalizations.of(context)!;

    _messages.add(ChatUiMessage(
      id: 1,
      text: l10n.chatIntroGeneric,
      isUser: false,
      timestamp: DateTime.now(),
    ));
    _isIntroAdded = true;
    _scrollToBottom();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addIntroMessage();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send([String? overrideText]) async {
    final text = (overrideText ?? _ctrl.text).trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatUiMessage(
        id: _messages.length + 1,
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });
    if (overrideText == null) _ctrl.clear();
    _scrollToBottom();

    ChatPersistenceService.saveMessage(
      username: _username,
      message: text,
      isUser: true,
    );

    try {
      final reply = await AiChatService.sendMessage(
        username: _username,
        message: text,
      );

      if (!mounted) return;

      setState(() {
        _isTyping = false;
        _messages.add(
          ChatUiMessage(
            id: _messages.length + 1,
            text: reply,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
      _scrollToBottom();

      ChatPersistenceService.saveMessage(
        username: _username,
        message: reply,
        isUser: false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(ChatUiMessage(
          id: _messages.length + 1,
          text: "Sorry, I encountered an error: $e",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    }
  }

  String _formatTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = bottomInset > 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            children: [
              _ChatHeader(
                l10n: AppLocalizations.of(context)!,
                showDeleteButton: _messages.length > 1,
                onDeletePressed: _confirmClearChat,
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (_isTyping && i == _messages.length) {
                      return const _TypingBubble();
                    }
                    final msg = _messages[i];
                    return _MessageBubble(
                      message: msg,
                      timeLabel: _formatTime(msg.timestamp),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: TextField(
                            controller: _ctrl,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _send(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(
                                color: Color(0xFFD1D5DB),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: GestureDetector(
                        onTap: _hasText ? () => _send() : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: _hasText
                                ? const LinearGradient(
                              colors: [Color(0xFF4A90E2), Color(0xFF2563EB)],
                            )
                                : const LinearGradient(
                              colors: [Color(0xFFE2E8F0), Color(0xFFE2E8F0)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: _hasText
                                ? [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                                : null,
                          ),
                          child: Icon(
                            Icons.send_rounded,
                            color: _hasText ? Colors.white : const Color(0xFF9CA3AF),
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: isKeyboardOpen
          ? null
          : BottomNavBar(
        active: NavTab.chat,
        onTap: widget.onNavigate,
      ),
    );
  }
}

// ── Chat Header ───────────────────────────────────────────────────────
class _ChatHeader extends StatefulWidget {
  final AppLocalizations l10n;
  final bool showDeleteButton;
  final VoidCallback onDeletePressed;

  const _ChatHeader({
    required this.l10n,
    required this.showDeleteButton,
    required this.onDeletePressed,
  });

  @override
  State<_ChatHeader> createState() => _ChatHeaderState();
}

class _ChatHeaderState extends State<_ChatHeader> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF2563EB)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'BanHops AI',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(width: 8),
                ScaleTransition(
                  scale: _scale,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF22C55E),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (widget.showDeleteButton)
            GestureDetector(
              onTap: widget.onDeletePressed,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFEE2E2),
                  ),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFEF4444),
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Message Bubble ─────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final ChatUiMessage message;
  final String timeLabel;

  const _MessageBubble({
    required this.message,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF2563EB)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 15),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.76,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF2563EB) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(22),
                  topRight: const Radius.circular(22),
                  bottomLeft: Radius.circular(isUser ? 22 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 22),
                ),
                border: isUser
                    ? null
                    : Border.all(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    softWrap: true,
                    style: TextStyle(
                      color: isUser ? Colors.white : const Color(0xFF1F2937),
                      fontSize: 15,
                      fontWeight: isUser ? FontWeight.w500 : FontWeight.w400,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      timeLabel,
                      style: TextStyle(
                        color: isUser ? Colors.white60 : const Color(0xFF9CA3AF),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Typing Bubble ─────────────────────────────────────────────────────
class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF2563EB)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 15),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _ctrl,
                  builder: (_, __) {
                    final t = ((_ctrl.value + i * 0.22) % 1.0);
                    final offset = sin(t * pi * 2) * 2.5;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.5),
                      child: Transform.translate(
                        offset: Offset(0, offset),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2563EB),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}