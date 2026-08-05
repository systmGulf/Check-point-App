import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/register_account/repo/register_account_repo_impl.dart';

import '../../../../../../../core/animations/animations.dart';
import '../../../../../../../core/contoller/roles_login_cubit/login_cubit.dart';
import '../../../../../../../core/enums/role_enum.dart';
import '../../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../../core/services/biometric_login_service.dart';
import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/widgets/app_top_snack_bar.dart';
import '../../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../../features/user_role/common/constants/auth_animation_constants.dart';
import '../../../../../../../features/user_role/common/widgets/auth_credentials_fields.dart';
import '../../../../../../../features/user_role/common/widgets/auth_login_body.dart';
import '../../../../../../../features/user_role/common/widgets/biometric_login_button.dart';
import '../../../../../employee/employee_auth/ui/views/widgets/text_terms_and_coditions.dart';
import 'header_text.dart';
import 'admin_login_bloc_listener.dart';

class AdminLoginScreenBody extends StatefulWidget {
  const AdminLoginScreenBody({super.key});

  @override
  State<AdminLoginScreenBody> createState() => _AdminLoginScreenBodyState();
}

class _AdminLoginScreenBodyState extends State<AdminLoginScreenBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SavedLoginAccount? _savedAccount;
  bool _showBiometricLogin = false;
  bool _autoBiometricTriggered = false;

  @override
  void initState() {
    super.initState();
    _loadSavedAccount();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLoginBody(
      roleLabel: 'Admin'.tr(),
      title: 'Welcome Back!'.tr(),
      subtitle: 'Sign in to your account as Admin'.tr(),
      imageAsset: 'assets/images/admin.png',
      formChild: Form(
        key: _formKey,
        child: Column(
          children: [
            AnimatedHeaderWidget(
              child: const HeaderText(),
            ),
            verticalSpace(AuthAnimationConstants.verticalSpaceLarge),
            AnimatedByWidgetType(
              widgetType: WidgetAnimationType.container,
              delayDuration: AuthAnimationConstants.formDelay,
              child: AuthCredentialsFields(
                emailController: _emailController,
                passwordController: _passwordController,
              ),
            ),
            verticalSpace(18),
            CustomAppButton(
              onPressed: () {
                TextInput.finishAutofillContext(shouldSave: true);
                _validateAndLogin();
              },
              textButton: 'Sign In'.tr(),
              buttonColor: ColorsManger.primaryColor,
            ),
            if (_showBiometricLogin && _savedAccount != null) ...[
              BiometricLoginButton(
                savedEmail: _savedAccount!.email,
                onPressed: _loginWithBiometrics,
              ),
            ],
            const AdminLoginBlocListener(),
          ],
        ),
      ),
      footer: AnimatedByWidgetType(
        widgetType: WidgetAnimationType.text,
        delayDuration: AuthAnimationConstants.termsDelay,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: const TextTermsAndCondition(),
        ),
      ),
    );
  }

  Future<void> _validateAndLogin() async {
    if (_formKey.currentState!.validate()) {
      final mobileId = await getId();
      if (!mounted) return;
      context.read<LoginCubit>().doLogin(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            role: Role.Admin,
            mobileId: mobileId!,
          );
    }
  }

  Future<void> _loadSavedAccount() async {
    final cubit = context.read<LoginCubit>();
    final savedAccount = await cubit.getSavedLoginForRole(Role.Admin);
    final canUseBiometric = await cubit.canUseBiometricLogin(Role.Admin);
    if (!mounted) return;

    setState(() {
      _savedAccount = savedAccount;
      _showBiometricLogin = canUseBiometric;
      if (savedAccount != null) {
        _emailController.text = savedAccount.email;
      }
    });

    if (canUseBiometric && !_autoBiometricTriggered) {
      _autoBiometricTriggered = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loginWithBiometrics();
        }
      });
    }
  }

  Future<void> _loginWithBiometrics() async {
    final mobileId = await getId();
    if (!mounted || mobileId == null) return;

    final result = await context.read<LoginCubit>().loginWithBiometrics(
          role: Role.Admin,
          mobileId: mobileId,
        );

    if (!mounted) return;
    if (result == BiometricLoginResult.unavailable) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: 'Biometric login is not available on this device'.tr(),
        ),
      );
    }
  }
}
