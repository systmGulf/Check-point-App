import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../features/user_role/common/widgets/auth_header_widget.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthHeaderWidget(
      label: 'Admin'.tr(),
      title: 'Welcome Back!'.tr(),
      subtitle: 'Sign in to your account as Admin'.tr(),
    );
  }
}
