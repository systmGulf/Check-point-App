import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/contoller/roles_login_cubit/login_cubit.dart';
import '../../../../../../../core/helpers/app_regex.dart';
import '../../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../../../../../../core/widgets/password_validator.dart';
import 'supervisor_login_bloc_listener.dart';

class SupervisorEmailAndPasswordTextField extends StatefulWidget {
  const SupervisorEmailAndPasswordTextField({super.key});

  @override
  State<SupervisorEmailAndPasswordTextField> createState() =>
      _SupervisorEmailAndPasswordTextFieldState();
}

class _SupervisorEmailAndPasswordTextFieldState
    extends State<SupervisorEmailAndPasswordTextField> {
  late TextEditingController emailController;
  late TextEditingController passwordTextController;
  bool isObscure = true;

  bool hasLowercase = false;
  bool hasUppercase = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;
  bool hasMinLength = false;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  @override
  void initState() {
    emailController = BlocProvider.of<LoginCubit>(context).emailController;
    passwordTextController =
        BlocProvider.of<LoginCubit>(context).passwordTextController;
    setupPasswordControllerListener();
    super.initState();
  }

  void setupPasswordControllerListener() {
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
                controller: emailController,
                keyboardType: TextInputType.name,
                icon: Icons.person,
                autofillHints: const [
                  AutofillHints.email,
                  AutofillHints.username
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter user name'.tr();
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
                keyboardType: TextInputType.visiblePassword,
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
              verticalSpace(1),
              verticalSpace(10),
              CustomAppButton(
                  onPressed: () {
                    TextInput.finishAutofillContext();
                    validateAndLogin();
                  },
                  textButton: 'Sign In'.tr(),
                  buttonColor: ColorsManger.primaryColor),
              const SupervisorLoginBlocListener(),
            ]),
          )),
    );
  }

  validateAndLogin() async {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<LoginCubit>(context).doLogin();
    }
  }
}
