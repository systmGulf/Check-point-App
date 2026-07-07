import 'package:flutter/material.dart';

import '../../../../../../../../core/widgets/build_custom_app_bar.dart';
import '../supervisor_login_screen_body.dart';

class SupervisorLoginScreen extends StatelessWidget {
  const SupervisorLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, ""),
      body: const SupervisorLoginScreenBody(),
    );
  }
}
