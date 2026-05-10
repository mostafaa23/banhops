import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../services/signup_service.dart'; // ✅

class SignUpScreen extends StatefulWidget {
  final VoidCallback onSignInTap;
  final VoidCallback onSignUpSuccess;

  const SignUpScreen({
    super.key,
    required this.onSignInTap,
    required this.onSignUpSuccess,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey        = GlobalKey<FormState>();
  final _firstName      = TextEditingController();
  final _lastName       = TextEditingController();
  final _username       = TextEditingController();
  final _email          = TextEditingController();
  final _phone          = TextEditingController();
  final _password       = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _obscurePass    = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _username.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  String? _required(String? v, String errorMsg) {
    if (v == null || v.trim().isEmpty) return errorMsg;
    return null;
  }

  String? _validateEmail(String? v, AppLocalizations l10n) {
    final base = _required(v, l10n.emailRequired);
    if (base != null) return base;
    final regex = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.\-]+$');
    if (!regex.hasMatch(v!.trim())) return l10n.invalidEmail;
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone number is required';
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) return 'Enter a valid phone number';
    return null;
  }

  String? _validatePassword(String? v, AppLocalizations l10n) {
    final base = _required(v, l10n.passwordRequired);
    if (base != null) return base;
    if (v!.length < 6) return l10n.passwordTooShort;
    return null;
  }

  String? _validateConfirm(String? v, AppLocalizations l10n) {
    final base = _required(v, l10n.confirmPasswordRequired);
    if (base != null) return base;
    if (v != _password.text) return l10n.passwordsDoNotMatch;
    return null;
  }

  // ✅ _submit الجديدة مع SignupService
  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      final result = await SignupService.signup(
        firstName: _firstName.text.trim(),
        lastName:  _lastName.text.trim(),
        username:  _username.text.trim(),
        password:  _password.text.trim(),
      );

      print("SIGNUP SUCCESS:");
      print(result);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created successfully"),
        ),
      );

      widget.onSignUpSuccess();

    } catch (e) {
      print("SIGNUP ERROR:");
      print(e);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [

          // ── Fixed Blue Header ──────────────────────────────
          _FixedHeader(onBack: widget.onSignInTap, title: l10n.signUp),

          // ── Scrollable Form ────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [

                        // First + Last name
                        Row(
                          children: [
                            Expanded(
                              child: _LabeledField(
                                label: l10n.firstName.toUpperCase(),
                                hint: l10n.firstNameHint,
                                controller: _firstName,
                                validator: (v) =>
                                    _required(v, l10n.firstNameRequired),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _LabeledField(
                                label: l10n.lastName.toUpperCase(),
                                hint: l10n.lastNameHint,
                                controller: _lastName,
                                validator: (v) =>
                                    _required(v, l10n.lastNameRequired),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        _LabeledField(
                          label: l10n.username.toUpperCase(),
                          hint: l10n.usernameHint,
                          controller: _username,
                          validator: (v) =>
                              _required(v, l10n.usernameRequired),
                        ),

                        const SizedBox(height: 16),

                        _LabeledField(
                          label: l10n.email.toUpperCase(),
                          hint: l10n.emailHint,
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => _validateEmail(v, l10n),
                        ),

                        const SizedBox(height: 16),

                        // Phone field
                        _LabeledField(
                          label: 'PHONE NUMBER',
                          hint: '+20 1XX XXX XXXX',
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[\d\+\-\s\(\)]'),
                            ),
                          ],
                          prefix: const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.phone_outlined,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
                          ),
                          validator: _validatePhone,
                        ),

                        const SizedBox(height: 16),

                        _LabeledField(
                          label: l10n.password.toUpperCase(),
                          hint: l10n.passwordHint,
                          controller: _password,
                          obscure: _obscurePass,
                          validator: (v) => _validatePassword(v, l10n),
                          suffix: IconButton(
                            icon: Icon(
                              _obscurePass
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                            ),
                            onPressed: () => setState(
                                    () => _obscurePass = !_obscurePass),
                          ),
                        ),

                        const SizedBox(height: 16),

                        _LabeledField(
                          label: l10n.confirmPassword.toUpperCase(),
                          hint: l10n.passwordHint,
                          controller: _confirmPassword,
                          obscure: _obscureConfirm,
                          validator: (v) => _validateConfirm(v, l10n),
                          suffix: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                            ),
                            onPressed: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ✅ Sign Up Button — onPressed: _submit
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF212121),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Text(l10n.signUp),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Sign In row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.alreadyHaveAccount,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: widget.onSignInTap,
                              child: Text(
                                l10n.signIn,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Fixed Blue Header ────────────────────────────────────────────
class _FixedHeader extends StatelessWidget {
  final VoidCallback onBack;
  final String title;

  const _FixedHeader({required this.onBack, required this.title});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5BAEE8), Color(0xFF4A90E2)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned(
                top: 8,
                left: 16,
                child: _CircleIconButton(
                  icon: Icons.arrow_back_ios_new,
                  onTap: onBack,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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

// ── Labeled Field ────────────────────────────────────────────────
class _LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffix;
  final Widget? prefix;
  final String? Function(String?)? validator;

  const _LabeledField({
    required this.label,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.keyboardType,
    this.inputFormatters,
    this.suffix,
    this.prefix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
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
              if (prefix != null) prefix!,
              Expanded(
                child: TextFormField(
                  controller: controller,
                  obscureText: obscure,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  validator: validator,
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
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 6),
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

// ── Circle Icon Button ───────────────────────────────────────────
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.2),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

// ── Wave Clipper ─────────────────────────────────────────────────
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width * 0.25, size.height,
      size.width * 0.5,  size.height - 25,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height - 50,
      size.width,        size.height - 15,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}