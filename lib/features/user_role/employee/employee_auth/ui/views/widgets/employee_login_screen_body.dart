import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/register_account/repo/register_account_repo_impl.dart';

import '../../../../../../../core/contoller/roles_login_cubit/login_cubit.dart';
import '../../../../../../../core/enums/role_enum.dart';
import '../../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/widgets/custom_app_button.dart';
import 'email_and_password_text_feild.dart';
import 'employee_login_bloc_listener.dart';
import 'employee_login_image_and_text.dart';
import 'text_terms_and_coditions.dart';

class EmployeeLoginScreenBody extends StatelessWidget {
  const EmployeeLoginScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: BlocProvider.of<LoginCubit>(context).formKey,
          child: Column(
            children: [
              verticalSpace(38),
              const EmployeeLoginImageAndText(),
              verticalSpace(30),
              const EmailAndPasswordTextField(),
              verticalSpace(1),
              verticalSpace(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomAppButton(
                    onPressed: () {
                      TextInput.finishAutofillContext(shouldSave: true);
                      validateAndLogin(context);
                    },
                    textButton: 'Sign In'.tr(),
                    buttonColor: ColorsManger.primaryColor),
              ),
              const EmployeeLoginBlocListener(),
              verticalSpace(20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: TextTermsAndCondition(),
              )
            ],
          ),
        ),
      ),
    );
  }

  validateAndLogin(BuildContext context) async {
    if (BlocProvider.of<LoginCubit>(context).formKey.currentState!.validate()) {
      String? mobileId = await getId();
      if (!context.mounted) return;

      BlocProvider.of<LoginCubit>(context)
          .doLogin(role: Role.Employee, mobileId: mobileId!);
    }
  }
}
