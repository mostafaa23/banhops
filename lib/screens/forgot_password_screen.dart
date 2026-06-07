import 'package:flutter/material.dart';
import '../services/forgot_password_service.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

enum _Step { credentials, showPassword }

class ForgotPasswordScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onResetSuccess;

  const ForgotPasswordScreen({
    super.key,
    required this.onBack,
    required this.onResetSuccess,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  _Step _step = _Step.credentials;

  final _credentialsKey = GlobalKey<FormState>();

  // Text controllers for username and email
  final _username = TextEditingController();
  final _email = TextEditingController();

  // Field variable to store the retrieved password
  String _recoveredPassword = '';

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    super.dispose();
  }

  String _title(AppLocalizations l10n) {
    switch (_step) {
      case _Step.credentials:
        return 'Forgot Password';
      case _Step.showPassword:
        return 'Password Recovery';
    }
  }

  String _description(AppLocalizations l10n) {
    switch (_step) {
      case _Step.credentials:
        return 'Enter your registered username and email address';
      case _Step.showPassword:
        return 'Your recovered password is:';
    }
  }

  void _handleBack() {
    if (_step == _Step.credentials) {
      widget.onBack();
    } else {
      setState(() => _step = _Step.credentials);
    }
  }

  String? _required(String? v, String message) {
    if (v == null || v.trim().isEmpty) return message;
    return null;
  }

  String? _validateEmail(String? v, AppLocalizations l10n) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final r = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.\-]+$');
    if (!r.hasMatch(v.trim())) return 'Invalid email address';
    return null;
  }

  Future<void> _submitCredentials() async {
    if (!(_credentialsKey.currentState?.validate() ?? false)) return;
    try {
      final password = await ForgotPasswordService.recoverPassword(
        username: _username.text.trim(),
        email:    _email.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _recoveredPassword = password;
        _step = _Step.showPassword;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: _WaveClipper(),
                  child: Container(
                    height: 240,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _CircleIconButton(
                          icon: Icons.arrow_back_ios_new,
                          onTap: _handleBack,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        _title(l10n),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: KeyedSubtree(
                    key: ValueKey(_step),
                    child: _buildStepContent(l10n),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          _description(l10n),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 28),
        switch (_step) {
          _Step.credentials  => _buildCredentials(l10n),
          _Step.showPassword => _buildShowPassword(),
        },
      ],
    );
  }

  Widget _buildCredentials(AppLocalizations l10n) {
    return Form(
      key: _credentialsKey,
      child: Column(
        children: [
          // Username Input Field
          _LabeledField(
            label: 'USERNAME',
            hint: 'Enter your username',
            controller: _username,
            keyboardType: TextInputType.text,
            validator: (v) => _required(v, 'Username is required'),
          ),
          const SizedBox(height: 16),

          // Email Input Field
          _LabeledField(
            label: 'EMAIL ADDRESS',
            hint: 'Enter your email',
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => _validateEmail(v, l10n),
          ),
          const SizedBox(height: 32),
          _PrimaryButton(label: 'SUBMIT', onPressed: _submitCredentials),
        ],
      ),
    );
  }

  Widget _buildShowPassword() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF86EFAC)),
          ),
          child: Column(
            children: [
              const Icon(Icons.lock_open_rounded,
                  color: Color(0xFF16A34A), size: 48),
              const SizedBox(height: 16),
              const Text(
                'YOUR PASSWORD',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF15803D),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _recoveredPassword,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF14532D),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _PrimaryButton(
          label: 'LOG IN',
          onPressed: widget.onResetSuccess,
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const _LabeledField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.keyboardType,
    this.suffix,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6A7282),
              letterSpacing: 1.2,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  obscureText: obscure,
                  keyboardType: keyboardType,
                  validator: validator,
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(color: AppColors.textMuted),
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  ),
                ),
              ),
              if (suffix != null) suffix!,
            ],
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF212121),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF212121).withAlpha(128),
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withAlpha(51),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height - 20,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 40,
      size.width,
      size.height - 10,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}