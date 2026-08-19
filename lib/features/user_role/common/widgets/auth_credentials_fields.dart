import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/app_regex.dart';
import '../../../../core/helpers/app_spaces.dart';
import '../../../../core/styles/colors.dart';

class AuthCredentialsFields extends StatefulWidget {
  const AuthCredentialsFields({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<AuthCredentialsFields> createState() => _AuthCredentialsFieldsState();
}

class _AuthCredentialsFieldsState extends State<AuthCredentialsFields> {
  bool _isObscure = true;
  bool _hasLowercase = false;
  bool _hasUppercase = false;
  bool _hasSpecialChar = false;
  bool _hasNumber = false;
  bool _hasMinLength = false;

  @override
  void initState() {
    super.initState();
    widget.passwordController.addListener(_handlePasswordChanged);
  }

  @override
  void dispose() {
    widget.passwordController.removeListener(_handlePasswordChanged);
    super.dispose();
  }

  void _handlePasswordChanged() {
    setState(() {
      _hasLowercase = AppRegex.hasLowerCase(widget.passwordController.text);
      _hasUppercase = AppRegex.hasUpperCase(widget.passwordController.text);
      _hasSpecialChar = AppRegex.hasSpecialCharacter(widget.passwordController.text);
      _hasNumber = AppRegex.hasNumber(widget.passwordController.text);
      _hasMinLength = AppRegex.hasMinLength(widget.passwordController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Email field ──────────────────────────────────────────────────
        _LoginField(
          controller: widget.emailController,
          hint: 'Email'.tr(),
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email, AutofillHints.username],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter user name'.tr();
            }
            return null;
          },
        ),
        verticalSpace(14),

        // ── Password field ───────────────────────────────────────────────
        _LoginField(
          controller: widget.passwordController,
          hint: 'Password'.tr(),
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _isObscure,
          autofillHints: const [AutofillHints.password],
          keyboardType: TextInputType.visiblePassword,
          suffixIcon: IconButton(
            onPressed: () => setState(() => _isObscure = !_isObscure),
            icon: Icon(
              _isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: Colors.grey.shade400,
              size: 20.sp,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || !AppRegex.isPasswordValid(value)) {
              return 'Please a valid password'.tr();
            }
            return null;
          },
        ),
        verticalSpace(16),

        // ── Password validation hints ────────────────────────────────────
        _PasswordHints(
          hasLowercase: _hasLowercase,
          hasUppercase: _hasUppercase,
          hasNumber: _hasNumber,
          hasSpecialChar: _hasSpecialChar,
          hasMinLength: _hasMinLength,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Clean text field
// ─────────────────────────────────────────────────────────────────────────────
class _LoginField extends StatelessWidget {
  const _LoginField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.autofillHints,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      validator: validator,
      style: TextStyle(fontSize: 14.sp, color: const Color(0xFF1A1A2E)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.sp),
        prefixIcon: Icon(prefixIcon, color: Colors.grey.shade400, size: 20.sp),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: ColorsManger.primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Password strength hints with checkmarks
// ─────────────────────────────────────────────────────────────────────────────
class _PasswordHints extends StatelessWidget {
  const _PasswordHints({
    required this.hasLowercase,
    required this.hasUppercase,
    required this.hasNumber,
    required this.hasSpecialChar,
    required this.hasMinLength,
  });

  final bool hasLowercase, hasUppercase, hasNumber, hasSpecialChar, hasMinLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _HintRow('Must have at least 1 lowercase'.tr(), hasLowercase),
          verticalSpace(6),
          _HintRow('Must have at least 1 number'.tr(), hasNumber),
          verticalSpace(6),
          _HintRow('Must have at least 1 uppercase'.tr(), hasUppercase),
          verticalSpace(6),
          _HintRow('Must have at least 1 special character'.tr(), hasSpecialChar),
          verticalSpace(6),
          _HintRow('at least 8 characters'.tr(), hasMinLength),
        ],
      ),
    );
  }
}

class _HintRow extends StatelessWidget {
  const _HintRow(this.text, this.met);
  final String text;
  final bool met;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          size: 16.sp,
          color: met ? Colors.green : Colors.grey.shade400,
        ),
        horizontalSpace(8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: met ? Colors.green.shade700 : Colors.black54,
              decoration: met ? TextDecoration.lineThrough : null,
              decorationColor: Colors.green.shade400,
            ),
          ),
        ),
      ],
    );
  }
}
