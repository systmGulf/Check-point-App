import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/register_account/repo/register_account_repo_impl.dart';

import '../../../../../../../core/contoller/roles_login_cubit/login_cubit.dart';
import '../../../../../../../core/enums/role_enum.dart';
import '../../../../../../../core/helpers/app_regex.dart';
import '../../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../../core/services/biometric_login_service.dart';
import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/widgets/app_top_snack_bar.dart';
import '../../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../../../../../../core/widgets/password_validator.dart';
import '../../../../../common/widgets/biometric_login_button.dart';
import 'admin_login_bloc_listener.dart';

class AdminEmailAndPasswordTextField extends StatefulWidget {
  const AdminEmailAndPasswordTextField({
    super.key,
  });

  @override
  State<AdminEmailAndPasswordTextField> createState() =>
      _AdminEmailAndPasswordTextFieldState();
}

class _AdminEmailAndPasswordTextFieldState
    extends State<AdminEmailAndPasswordTextField> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  bool isObscure = true;
  bool hasLowercase = false;
  bool hasUppercase = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;
  bool hasMinLength = false;
  final GlobalKey<FormState> formKey = GlobalKey();
  SavedLoginAccount? _savedAccount;
  bool _showBiometricLogin = false;
  bool _autoBiometricTriggered = false;

  @override
  void initState() {
    super.initState();
    _setupPasswordControllerListener();
    _loadSavedAccount();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  void _setupPasswordControllerListener() {
    passwordTextController.addListener(() {
      setState(() {
        hasLowercase = AppRegex.hasLowerCase(passwordTextController.text);
        hasUppercase = AppRegex.hasUpperCase(passwordTextController.text);
        hasSpecialCharacters =
            AppRegex.hasSpecialCharacter(passwordTextController.text);
        hasNumber = AppRegex.hasNumber(passwordTextController.text);
        hasMinLength = AppRegex.hasMinLength(passwordTextController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      child: Form(
          key: formKey,
          child: AutofillGroup(
            child: Column(children: [
              CustomAppTextFormField(
                autofillHints: const [
                  AutofillHints.email,
                  AutofillHints.username
                ],
                controller: emailController,
                icon: Icons.person,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter username'.tr();
                  }
                  return null;
                },
                hint: 'Email'.tr(),
              ),
              verticalSpace(10),
              CustomAppTextFormField(
                autofillHints: const [AutofillHints.password],
                controller: passwordTextController,
                obscureText: isObscure,
                validator: (value) {
                  if (value!.isEmpty || !AppRegex.isPasswordValid(value)) {
                    return 'Please a valid password'.tr();
                  }
                  return null;
                },
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: Icon(
                      isObscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    )),
                icon: Icons.person,
                hint: 'Password'.tr(),
              ),
              verticalSpace(10),
              PasswordValidation(
                hasLowerCase: hasLowercase,
                hasUpperCase: hasUppercase,
                hasNumber: hasNumber,
                hasSpecialCharacter: hasSpecialCharacters,
                hasMinLength: hasMinLength,
              ),
              verticalSpace(10),
              CustomAppButton(
                  onPressed: () {
                    TextInput.finishAutofillContext(shouldSave: true);
                    _validateAndLogin(context);
                  },
                  textButton: 'Sign In'.tr(),
                  buttonColor: ColorsManger.primaryColor),
              if (_showBiometricLogin && _savedAccount != null) ...[
                verticalSpace(12),
                BiometricLoginButton(
                  savedEmail: _savedAccount!.email,
                  onPressed: _loginWithBiometrics,
                ),
              ],
              const AdminLoginBlocListener()
            ]),
          )),
    );
  }

  Future<void> _validateAndLogin(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final mobileId = await getId();
      if (!context.mounted) return;
      context.read<LoginCubit>().doLogin(
            email: emailController.text.trim(),
            password: passwordTextController.text,
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
        emailController.text = savedAccount.email;
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
