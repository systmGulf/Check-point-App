import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../../../core/styles/styles.dart';
import '../../../../../../employee/employee_auth/ui/views/widgets/text_terms_and_coditions.dart';
import '../email_and_password_text_field.dart';

class SupervisorLoginScreen extends StatelessWidget {
  const SupervisorLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27),
          child: ListView(
            children: [
              verticalSpace(38),
              Text(
                'Welcome Back!'.tr(),
                style: AppStylesManger.font24regulerBlack
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                'Sign in to your account as Supervisor'.tr(),
                style: AppStylesManger.font14RegularBlack
                    .copyWith(color: Colors.grey, fontSize: 14),
              ),
              verticalSpace(22),
              const SupervisorEmailAndPasswordTextField(),
              verticalSpace(20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextTermsAndCondition(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
