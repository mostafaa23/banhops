import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

enum _Step { credentials, verification, newPassword }

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
  final _passwordKey = GlobalKey<FormState>();

  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _newPass = TextEditingController();
  final _confirmPass = TextEditingController();

  final List<TextEditingController> _codeCtrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _codeNodes = List.generate(6, (_) => FocusNode());

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _phone.dispose();
    _email.dispose();
    _newPass.dispose();
    _confirmPass.dispose();
    for (final c in _codeCtrls) {
      c.dispose();
    }
    for (final n in _codeNodes) {
      n.dispose();
    }
    super.dispose();
  }

  String _title(AppLocalizations l10n) {
    switch (_step) {
      case _Step.credentials:
        return l10n.forgotPassword;
      case _Step.verification:
        return l10n.verifyCode;
      case _Step.newPassword:
        return l10n.newPassword;
    }
  }

  String _description(AppLocalizations l10n) {
    switch (_step) {
      case _Step.credentials:
        return l10n.forgotPasswordStep1Desc;
      case _Step.verification:
        return l10n.forgotPasswordStep2Desc;
      case _Step.newPassword:
        return l10n.forgotPasswordStep3Desc;
    }
  }

  void _handleBack() {
    if (_step == _Step.credentials) {
      widget.onBack();
    } else if (_step == _Step.verification) {
      setState(() => _step = _Step.credentials);
    } else {
      setState(() => _step = _Step.verification);
    }
  }

  String? _required(String? v, String message) {
    if (v == null || v.trim().isEmpty) return message;
    return null;
  }

  String? _validateEmail(String? v, AppLocalizations l10n) {
    final base = _required(v, l10n.emailRequired);
    if (base != null) return base;
    final r = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.\-]+$');
    if (!r.hasMatch(v!.trim())) return l10n.invalidEmail;
    return null;
  }

  void _submitCredentials() {
    if (_credentialsKey.currentState?.validate() ?? false) {
      setState(() => _step = _Step.verification);
    }
  }

  void _verifyCode(AppLocalizations l10n) {
    final code = _codeCtrls.map((c) => c.text).join();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.completeSixDigitCode)),
      );
      return;
    }
    setState(() => _step = _Step.newPassword);
  }

  void _resetPassword() {
    if (!(_passwordKey.currentState?.validate() ?? false)) return;
    if (_newPass.text != _confirmPass.text) return;
    widget.onResetSuccess();
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
          _Step.credentials => _buildCredentials(l10n),
          _Step.verification => _buildVerification(l10n),
          _Step.newPassword => _buildNewPassword(l10n),
        },
      ],
    );
  }

  Widget _buildCredentials(AppLocalizations l10n) {
    return Form(
      key: _credentialsKey,
      child: Column(
        children: [
          _LabeledField(
            label: l10n.phoneNumber.toUpperCase(),
            hint: '01xxxxxxxxx',
            controller: _phone,
            keyboardType: TextInputType.phone,
            validator: (v) => _required(v, l10n.phoneRequired),
          ),
          const SizedBox(height: 16),
          _LabeledField(
            label: l10n.email.toUpperCase(),
            hint: l10n.emailHint,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => _validateEmail(v, l10n),
          ),
          const SizedBox(height: 32),
          _PrimaryButton(label: l10n.send, onPressed: _submitCredentials),
        ],
      ),
    );
  }

  Widget _buildVerification(AppLocalizations l10n) {
    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: SizedBox(
                  width: 48,
                  height: 56,
                  child: TextField(
                    controller: _codeCtrls[i],
                    focusNode: _codeNodes[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFF3F4F6),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (v) {
                      if (v.isNotEmpty && i < 5) {
                        _codeNodes[i + 1].requestFocus();
                      } else if (v.isEmpty && i > 0) {
                        _codeNodes[i - 1].requestFocus();
                      }
                    },
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 32),
        _PrimaryButton(label: l10n.verify, onPressed: () => _verifyCode(l10n)),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            for (final c in _codeCtrls) {
              c.clear();
            }
          },
          child: Text(
            l10n.resendCode,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewPassword(AppLocalizations l10n) {
    final mismatch = _newPass.text.isNotEmpty &&
        _confirmPass.text.isNotEmpty &&
        _newPass.text != _confirmPass.text;

    return Form(
      key: _passwordKey,
      child: Column(
        children: [
          _LabeledField(
            label: l10n.newPassword.toUpperCase(),
            hint: l10n.passwordHint,
            controller: _newPass,
            obscure: _obscureNew,
            validator: (v) {
              if (v == null || v.isEmpty) return l10n.passwordRequired;
              if (v.length < 6) return l10n.passwordTooShort;
              return null;
            },
            onChanged: (_) => setState(() {}),
            suffix: IconButton(
              icon: Icon(
                _obscureNew
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textMuted,
              ),
              onPressed: () => setState(() => _obscureNew = !_obscureNew),
            ),
          ),
          const SizedBox(height: 16),
          _LabeledField(
            label: l10n.confirmPassword.toUpperCase(),
            hint: l10n.passwordHint,
            controller: _confirmPass,
            obscure: _obscureConfirm,
            validator: (v) {
              if (v == null || v.isEmpty) return l10n.confirmPasswordRequired;
              if (v != _newPass.text) return l10n.passwordsDoNotMatch;
              return null;
            },
            onChanged: (_) => setState(() {}),
            suffix: IconButton(
              icon: Icon(
                _obscureConfirm
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textMuted,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          if (mismatch) ...[
            const SizedBox(height: 12),
            Text(
              l10n.passwordsDoNotMatch,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ],
          const SizedBox(height: 24),
          _PrimaryButton(
            label: l10n.resetPassword,
            onPressed: (_newPass.text.isNotEmpty &&
                    _confirmPass.text.isNotEmpty &&
                    !mismatch)
                ? _resetPassword
                : null,
          ),
        ],
      ),
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
          disabledBackgroundColor: const Color(0xFF212121).withValues(alpha: 0.5),
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
      color: Colors.white.withValues(alpha: 0.2),
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
