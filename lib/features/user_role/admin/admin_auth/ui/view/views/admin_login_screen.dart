import 'package:flutter/material.dart';

import '../widgets/admin_login_screen_body.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AdminLoginScreenBody(),
    );
  }
}
