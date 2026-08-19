import 'package:flutter/material.dart';

import '../widgets/employee_login_screen_body.dart';

class EmployeeLoginScreen extends StatelessWidget {
  const EmployeeLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EmployeeLoginScreenBody(),
    );
  }
}
