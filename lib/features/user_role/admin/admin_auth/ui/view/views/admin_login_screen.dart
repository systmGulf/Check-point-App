import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/build_custom_app_bar.dart';
import '../widgets/admin_login_screen_body.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: buildCustomAppBar(context, ""),
      body: AdminLoginScreenBody(),
    );
  }
}
