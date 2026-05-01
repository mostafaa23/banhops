import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LanguageSelectionScreen extends StatelessWidget {
  final ValueChanged<Locale> onLanguageSelected;

  const LanguageSelectionScreen({super.key, required this.onLanguageSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Logo circle
              SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  clipBehavior: Clip.none, // ✅ Fix: عشان الصورة متتقطعش
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15), // ✅ Fix
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      top: -10,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 110,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Headings
              const Text(
                'الرجاء اختيار لغة',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please select a language.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9), // ✅ Fix
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 32),

              // Language buttons
              _LanguageButton(
                label: 'العربية',
                onTap: () => onLanguageSelected(const Locale('ar')),
              ),
              const SizedBox(height: 16),
              _LanguageButton(
                label: 'English',
                onTap: () => onLanguageSelected(const Locale('en')),
              ),

              const Spacer(flex: 2),

              // Footer
              Text(
                'Welcome to',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8), // ✅ Fix
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'BanHops',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Smart Route to Benha',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7), // ✅ Fix
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _LanguageButton({required this.label, required this.onTap});

  @override
  State<_LanguageButton> createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<_LanguageButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1), // ✅ Fix
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}