import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/register_account/repo/register_account_repo_impl.dart';

import '../../../../../../../../core/contoller/roles_login_cubit/login_cubit.dart';
import '../../../../../../../../core/enums/role_enum.dart';
import '../../../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../../../core/services/biometric_login_service.dart';
import '../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../core/widgets/app_top_snack_bar.dart';
import '../../../../../common/widgets/auth_credentials_fields.dart';
import '../../../../../common/widgets/auth_login_body.dart';
import '../../../../../common/widgets/biometric_login_button.dart';
import '../../../../../employee/employee_auth/ui/views/widgets/text_terms_and_coditions.dart';
import 'supervisor_login_bloc_listener.dart';

class SupervisorLoginScreenBody extends StatefulWidget {
  const SupervisorLoginScreenBody({super.key});

  @override
  State<SupervisorLoginScreenBody> createState() =>
      _SupervisorLoginScreenBodyState();
}

class _SupervisorLoginScreenBodyState extends State<SupervisorLoginScreenBody> {
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
      roleLabel: 'Supervisor'.tr(),
      title: 'Welcome Back!'.tr(),
      subtitle: 'Sign in to your account as Supervisor'.tr(),
      imageAsset: 'assets/images/manger.png',
      formChild: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthCredentialsFields(
              emailController: _emailController,
              passwordController: _passwordController,
            ),
            verticalSpace(24),
            SizedBox(
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  TextInput.finishAutofillContext(shouldSave: true);
                  _validateAndLogin();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManger.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  'Sign In'.tr(),
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            if (_showBiometricLogin && _savedAccount != null) ...[
              BiometricLoginButton(
                savedEmail: _savedAccount!.email,
                onPressed: _loginWithBiometrics,
              ),
            ],
            const SupervisorLoginBlocListener(),
          ],
        ),
      ),
      footer: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: TextTermsAndCondition(),
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
            role: Role.Supervisor,
            mobileId: mobileId!,
          );
    }
  }

  Future<void> _loadSavedAccount() async {
    final cubit = context.read<LoginCubit>();
    final savedAccount = await cubit.getSavedLoginForRole(Role.Supervisor);
    final canUseBiometric = await cubit.canUseBiometricLogin(Role.Supervisor);
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
          role: Role.Supervisor,
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
