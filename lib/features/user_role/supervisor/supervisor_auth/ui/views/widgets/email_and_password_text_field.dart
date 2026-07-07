import 'package:flutter/material.dart';

import '../../../../../common/widgets/auth_credentials_fields.dart';

class SupervisorEmailAndPasswordTextField extends StatefulWidget {
  const SupervisorEmailAndPasswordTextField({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<SupervisorEmailAndPasswordTextField> createState() =>
      _SupervisorEmailAndPasswordTextFieldState();
}

class _SupervisorEmailAndPasswordTextFieldState
    extends State<SupervisorEmailAndPasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return AuthCredentialsFields(
      emailController: widget.emailController,
      passwordController: widget.passwordController,
    );
  }
}
