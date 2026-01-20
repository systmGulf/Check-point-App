import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/helpers/app_spaces.dart';
import '../../../../../employee/employee_auth/ui/views/widgets/text_terms_and_coditions.dart';
import 'email_and_password_text_field.dart';
import 'header_text.dart';

class AdminLoginScreenBody extends StatelessWidget {
  const AdminLoginScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 27),
        child: ListView(
          children: [
            verticalSpace(18),
            const HeaderText(),
            verticalSpace(22),
            const AdminEmailAndPasswordTextField(),
            verticalSpace(20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: TextTermsAndCondition(),
            )
          ],
        ),
      ),
    );
  }
}
