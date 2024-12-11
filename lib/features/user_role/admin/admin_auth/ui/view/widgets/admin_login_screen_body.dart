import 'email_and_password_text_field.dart';
import 'header_text.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/helpers/app_spaces.dart';
import '../../../../../employee/employee_auth/ui/views/widgets/text_terms_and_coditions.dart';

class AdminLoginScreenBody extends StatelessWidget {
  const AdminLoginScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 27),
        child: ListView(
          children: [
            verticalSpace(38),
            const HeaderText(),
            verticalSpace(22),
            const AdminEmailAndPasswordTextFeild(),
            verticalSpace(20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextTermsAndCondition(),
            )
          ],
        ),
      ),
    );
  }
}
