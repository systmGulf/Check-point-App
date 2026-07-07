import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets/auth_credentials_fields.dart';

class EmailAndPasswordTextField extends StatefulWidget {
  const EmailAndPasswordTextField({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<EmailAndPasswordTextField> createState() =>
      _EmailAndPasswordTextFieldState();
}

class _EmailAndPasswordTextFieldState extends State<EmailAndPasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      child: AuthCredentialsFields(
        emailController: widget.emailController,
        passwordController: widget.passwordController,
      ),
    );
  }
}
