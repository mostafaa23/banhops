import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LanguageSettingsScreen extends StatefulWidget {
  final Locale current;
  final ValueChanged<Locale> onApply;
  final VoidCallback onBack;

  const LanguageSettingsScreen({
    super.key,
    required this.current,
    required this.onApply,
    required this.onBack,
  });

  @override
  State<LanguageSettingsScreen> createState() =>
      _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  late Locale _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.current;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E293B),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: widget.onBack,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          // ✅ glass white/10
                          color: Colors.white.withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.10),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Title row
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            // ✅ Primary #4A90E2
                            color: const Color(0xFF4A90E2),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4A90E2)
                                    .withValues(alpha: 0.30),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.language,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Text(
                          'Select Language',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Current: ${widget.current.languageCode == 'ar' ? 'العربية' : 'English'}',
                      style: const TextStyle(
                        // ✅ #CBD5E1 = slate-300
                        color: Color(0xFFCBD5E1),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Language tiles ───────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                  child: Column(
                    children: [
                      _LanguageTile(
                        flag: '🇪🇬',
                        title: 'العربية',
                        subtitle: 'Arabic',
                        selected: _selected.languageCode == 'ar',
                        onTap: () =>
                            setState(() => _selected = const Locale('ar')),
                      ),
                      const SizedBox(height: 12),
                      _LanguageTile(
                        flag: '🇬🇧',
                        title: 'English',
                        subtitle: 'الإنجليزية',
                        selected: _selected.languageCode == 'en',
                        onTap: () =>
                            setState(() => _selected = const Locale('en')),
                      ),
                      const SizedBox(height: 24),

                      // Info note
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.10),
                          ),
                        ),
                        child: const Text(
                          'The new language will be applied to all app screens',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFCBD5E1), // ✅ slate-300
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Apply Button ─────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton.icon(
                    onPressed: () => widget.onApply(_selected),
                    style: ElevatedButton.styleFrom(
                      // ✅ Primary #4A90E2
                      backgroundColor: const Color(0xFF4A90E2),
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor:
                      const Color(0xFF4A90E2).withValues(alpha: 0.40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(Icons.check, size: 20),
                    label: const Text('Apply'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Language Tile ────────────────────────────────────────────────
class _LanguageTile extends StatelessWidget {
  final String flag;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.flag,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected
          // ✅ selected: Primary/20
              ? const Color(0xFF4A90E2).withValues(alpha: 0.20)
          // ✅ default: glass white/10
              : Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected
            // ✅ selected border: Primary #4A90E2
                ? const Color(0xFF4A90E2)
            // ✅ default border: white/10
                : Colors.white.withValues(alpha: 0.10),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Flag circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF4A90E2) // ✅ Primary
                    : Colors.white.withValues(alpha: 0.10), // ✅ glass
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(flag, style: const TextStyle(fontSize: 24)),
            ),

            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFFCBD5E1), // ✅ slate-300
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Check badge
            if (selected)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF4A90E2), // ✅ Primary
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}