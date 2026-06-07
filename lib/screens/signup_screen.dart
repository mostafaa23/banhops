import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../services/signup_service.dart';

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
  bool _isLoading      = false;

  // ✅ مؤشرات التحقق الحي (Real-time Indicators)
  bool _hasMinLength = false;
  bool _hasDigit     = false;
  bool _hasUppercase = false;
  bool _hasSpecialChar = false;
  bool _isEmailValid = false;
  bool _isPhoneValid = false;

  void _checkPassword(String value) {
    setState(() {
      _hasMinLength = value.length >= 8;
      _hasDigit     = value.contains(RegExp(r'[0-9]'));
      _hasUppercase = value.contains(RegExp(r'[A-Z]'));
      _hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*()_+|?]'));
    });
  }

  void _checkEmail(String value) {
    final emailRegex = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.\-]+$');
    setState(() {
      _isEmailValid = emailRegex.hasMatch(value.trim());
    });
  }

  void _checkPhone(String value) {
    final phoneRegex = RegExp(r'^01[0125][0-9]{8}$');
    setState(() {
      _isPhoneValid = phoneRegex.hasMatch(value.trim());
    });
  }

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

  // ✅ دالة الحفظ والإرسال المصفاة والمؤمنة
  Future<void> _submit() async {
    if (!_isPhoneValid || !_isEmailValid || !_hasMinLength || !_hasDigit || !_hasUppercase || !_hasSpecialChar) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("يرجى استيفاء جميع شروط المدخلات أولاً"),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final result = await SignupService.signup(
        firstName: _firstName.text.trim(),
        lastName:  _lastName.text.trim(),
        username:  _username.text.trim(),
        email:     _email.text.trim(),
        phone:     _phone.text.trim(),
        password:  _password.text.trim(),
      );

      print("SIGNUP SUCCESS: $result");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.accountCreatedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );

      widget.onSignUpSuccess();

    } catch (e) {
      print("SIGNUP ERROR: $e");

      if (!mounted) return;

      String errorMsg = e.toString().replaceAll('Exception: ', '');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildRequirementItem(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isMet ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isMet ? Colors.green : Colors.redAccent,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: isMet ? Colors.green.shade700 : Colors.red.shade400,
                fontWeight: isMet ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
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
                                validator: (v) => _required(v, l10n.firstNameRequired),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _LabeledField(
                                label: l10n.lastName.toUpperCase(),
                                hint: l10n.lastNameHint,
                                controller: _lastName,
                                validator: (v) => _required(v, l10n.lastNameRequired),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        _LabeledField(
                          label: l10n.username.toUpperCase(),
                          hint: l10n.usernameHint,
                          controller: _username,
                          validator: (v) => _required(v, l10n.usernameRequired),
                        ),

                        const SizedBox(height: 16),

                        _LabeledField(
                          label: l10n.email.toUpperCase(),
                          hint: l10n.emailHint,
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: _checkEmail,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return l10n.emailRequired;
                            if (!_isEmailValid) return l10n.invalidEmail;
                            return null;
                          },
                          footer: _buildRequirementItem("صيغة البريد الإلكتروني صحيحة", _isEmailValid),
                        ),

                        const SizedBox(height: 16),

                        _LabeledField(
                          label: l10n.phoneNumber.toUpperCase(),
                          hint: l10n.phoneNumberPlaceholder,
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          onChanged: _checkPhone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          prefix: const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.phone_outlined,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return l10n.phoneRequired;
                            if (!_isPhoneValid) return "رقم الهاتف غير صحيح";
                            return null;
                          },
                          footer: _buildRequirementItem(
                            "رقم محمول مصري صحيح",
                            _isPhoneValid,
                          ),
                        ),

                        const SizedBox(height: 16),

                        _LabeledField(
                          label: l10n.password.toUpperCase(),
                          hint: l10n.passwordHint,
                          controller: _password,
                          obscure: _obscurePass,
                          onChanged: _checkPassword,
                          validator: (v) {
                            if (v == null || v.isEmpty) return l10n.passwordRequired;
                            if (!_hasMinLength || !_hasDigit || !_hasUppercase || !_hasSpecialChar) {
                              return "يرجى استيفاء جميع شروط كلمة المرور";
                            }
                            return null;
                          },
                          suffix: IconButton(
                            icon: Icon(
                              _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                            ),
                            onPressed: () => setState(() => _obscurePass = !_obscurePass),
                          ),
                          footer: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRequirementItem("على الأقل 8 أحرف", _hasMinLength),
                              _buildRequirementItem("يحتوي على رقم واحد على الأقل (0-9)", _hasDigit),
                              _buildRequirementItem("يحتوي على حرف كبير واحد على الأقل (A-Z)", _hasUppercase),
                              _buildRequirementItem("يحتوي على رمز خاص (!@#\$%)", _hasSpecialChar),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        _LabeledField(
                          label: l10n.confirmPassword.toUpperCase(),
                          hint: l10n.passwordHint,
                          controller: _confirmPassword,
                          obscure: _obscureConfirm,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return l10n.confirmPasswordRequired;
                            if (v != _password.text) return l10n.passwordsDoNotMatch;
                            return null;
                          },
                          suffix: IconButton(
                            icon: Icon(
                              _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                            ),
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // زر التسجيل التفاعلي
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF212121),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                                : Text(l10n.signUp),
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
  final ValueChanged<String>? onChanged;
  final Widget? footer;

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
    this.onChanged,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
              if (footer != null) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: Color(0xFFF3F4F6), height: 1),
                ),
                footer!,
              ],
            ],
          ),
        ),
      ],
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