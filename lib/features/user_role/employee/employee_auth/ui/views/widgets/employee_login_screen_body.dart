import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/register_account/repo/register_account_repo_impl.dart';

import '../../../../../../../core/animations/animations.dart';
import '../../../../../../../core/contoller/roles_login_cubit/login_cubit.dart';
import '../../../../../../../core/enums/role_enum.dart';
import '../../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../common/constants/auth_animation_constants.dart';
import '../../../../../common/widgets/auth_credentials_fields.dart';
import '../../../../../common/widgets/auth_login_body.dart';
import 'employee_login_bloc_listener.dart';
import 'employee_login_image_and_text.dart';
import 'text_terms_and_coditions.dart';

class EmployeeLoginScreenBody extends StatefulWidget {
  const EmployeeLoginScreenBody({super.key});

  @override
  State<EmployeeLoginScreenBody> createState() =>
      _EmployeeLoginScreenBodyState();
}

class _EmployeeLoginScreenBodyState extends State<EmployeeLoginScreenBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLoginBody(
      roleLabel: 'Employee'.tr(),
      title: 'Welcome Back!'.tr(),
      subtitle: 'Sign in to your account as Employee'.tr(),
      imageAsset: 'assets/images/employee.png',
      formChild: Form(
        key: _formKey,
        child: Column(
          children: [
            AnimatedHeaderWidget(
              child: const EmployeeLoginImageAndText(),
            ),
            verticalSpace(30),
            AnimatedByWidgetType(
              widgetType: WidgetAnimationType.container,
              delayDuration: AuthAnimationConstants.formDelay,
              child: AuthCredentialsFields(
                emailController: _emailController,
                passwordController: _passwordController,
              ),
            ),
            verticalSpace(AuthAnimationConstants.verticalSpaceMedium),
            AnimatedByWidgetType(
              widgetType: WidgetAnimationType.button,
              delayDuration: AuthAnimationConstants.buttonDelay,
              child: CustomAppButton(
                onPressed: () {
                  TextInput.finishAutofillContext(shouldSave: true);
                  _validateAndLogin(context);
                },
                textButton: 'Sign In'.tr(),
                buttonColor: ColorsManger.primaryColor,
              ),
            ),
            const EmployeeLoginBlocListener(),
          ],
        ),
      ),
      footer: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TextTermsAndCondition(),
      ),
    );
  }

  Future<void> _validateAndLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final mobileId = await getId();
      if (!context.mounted) return;

      context.read<LoginCubit>().doLogin(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            role: Role.Employee,
            mobileId: mobileId!,
          );
    }
  }
}
