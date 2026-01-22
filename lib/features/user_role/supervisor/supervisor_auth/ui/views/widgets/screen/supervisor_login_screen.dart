import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/animations/animations.dart';
import '../../../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../common/constants/auth_animation_constants.dart';
import '../../../../../../common/widgets/auth_header_widget.dart';
import '../../../../../../employee/employee_auth/ui/views/widgets/text_terms_and_coditions.dart';
import '../email_and_password_text_field.dart';

class SupervisorLoginScreen extends StatelessWidget {
  const SupervisorLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, ""),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27),
          child: ListView(
            children: [
              verticalSpace(AuthAnimationConstants.verticalSpaceXLarge),
              AuthHeaderWidget(
                title: 'Welcome Back!'.tr(),
                subtitle: 'Sign in to your account as Supervisor'.tr(),
              ),
              verticalSpace(AuthAnimationConstants.verticalSpaceLarge),
              AnimatedByWidgetType(
                widgetType: WidgetAnimationType.container,
                delayDuration: AuthAnimationConstants.formDelay,
                child: const SupervisorEmailAndPasswordTextField(),
              ),
              verticalSpace(20),
              AnimatedByWidgetType(
                widgetType: WidgetAnimationType.text,
                delayDuration: AuthAnimationConstants.termsDelay,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextTermsAndCondition(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
