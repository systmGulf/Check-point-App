import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/animations/animations.dart';
import '../../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../../features/user_role/common/constants/auth_animation_constants.dart';
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
            verticalSpace(AuthAnimationConstants.verticalSpaceXLarge - 20),
            AnimatedHeaderWidget(
              child: const HeaderText(),
            ),
            verticalSpace(AuthAnimationConstants.verticalSpaceLarge),
            AnimatedByWidgetType(
              widgetType: WidgetAnimationType.container,
              delayDuration: AuthAnimationConstants.formDelay,
              child: const AdminEmailAndPasswordTextField(),
            ),
            verticalSpace(20),
            AnimatedByWidgetType(
              widgetType: WidgetAnimationType.text,
              delayDuration: AuthAnimationConstants.termsDelay,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: TextTermsAndCondition(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
