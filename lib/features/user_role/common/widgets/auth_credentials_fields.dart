import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/app_regex.dart';
import '../../../../core/helpers/app_spaces.dart';
import '../../../../core/widgets/custom_app_text_form_field.dart';
import '../../../../core/widgets/password_validator.dart';

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
  bool isObscure = true;
  bool hasLowercase = false;
  bool hasUppercase = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;
  bool hasMinLength = false;

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
      hasLowercase = AppRegex.hasLowerCase(widget.passwordController.text);
      hasUppercase = AppRegex.hasUpperCase(widget.passwordController.text);
      hasSpecialCharacters =
          AppRegex.hasSpecialCharacter(widget.passwordController.text);
      hasNumber = AppRegex.hasNumber(widget.passwordController.text);
      hasMinLength = AppRegex.hasMinLength(widget.passwordController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppTextFormField(
          autofillHints: const [
            AutofillHints.email,
            AutofillHints.username,
          ],
          keyboardType: TextInputType.emailAddress,
          controller: widget.emailController,
          prefixIcon: const Icon(Icons.person_outline),
          validator: (value) {
            if (value!.trim().isEmpty) {
              return 'Please enter user name'.tr();
            }
            return null;
          },
          hint: 'Email'.tr(),
        ),
        verticalSpace(12),
        CustomAppTextFormField(
          autofillHints: const [AutofillHints.password],
          controller: widget.passwordController,
          obscureText: isObscure,
          keyboardType: TextInputType.visiblePassword,
          prefixIcon: const Icon(Icons.lock_outline),
          validator: (value) {
            if (value!.isEmpty || !AppRegex.isPasswordValid(value)) {
              return 'Please a valid password'.tr();
            }
            return null;
          },
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isObscure = !isObscure;
              });
            },
            icon: Icon(
              isObscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey,
            ),
          ),
          hint: 'Password'.tr(),
        ),
        verticalSpace(12),
        PasswordValidation(
          hasLowerCase: hasLowercase,
          hasUpperCase: hasUppercase,
          hasNumber: hasNumber,
          hasSpecialCharacter: hasSpecialCharacters,
          hasMinLength: hasMinLength,
        ),
      ],
    );
  }
}
