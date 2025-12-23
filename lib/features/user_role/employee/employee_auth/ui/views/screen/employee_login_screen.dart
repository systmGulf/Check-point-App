import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/build_custom_app_bar.dart';
import '../widgets/employee_login_screen_body.dart';

class EmployeeLoginScreen extends StatelessWidget {
  const EmployeeLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: buildCustomAppBar(context, ""),
      body: EmployeeLoginScreenBody());
  }
}
