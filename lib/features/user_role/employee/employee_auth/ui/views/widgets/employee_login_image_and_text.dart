import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../features/user_role/common/widgets/auth_header_widget.dart';

/// Employee-specific login header displaying welcome message and role information
class EmployeeLoginImageAndText extends StatelessWidget {
  const EmployeeLoginImageAndText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthHeaderWidget(
            title: 'Welcome Back!'.tr(),
            subtitle: 'Sign in to your account as Employee'.tr(),
          ),
          const Row(children: []),
        ],
      ),
    );
  }
}
