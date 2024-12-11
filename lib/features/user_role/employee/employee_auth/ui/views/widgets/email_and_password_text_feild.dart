import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/contoller/roles_login_cubit/login_cubit.dart';
import '../../../../../../../core/helpers/app_regex.dart';
import '../../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../../../../../../core/widgets/password_validator.dart';

class EmailAndPasswordTextField extends StatefulWidget {
  const EmailAndPasswordTextField({
    super.key,
  });

  @override
  State<EmailAndPasswordTextField> createState() =>
      _EmailAndPasswordTextFieldState();
}

class _EmailAndPasswordTextFieldState extends State<EmailAndPasswordTextField> {
  late TextEditingController emailController;
  late TextEditingController passwordTextController;
  bool isObscure = true;

  bool hasLowercase = false;
  bool hasUppercase = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;
  bool hasMinLength = false;

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: [
        CustomAppTextFormField(
          controller: emailController,
          icon: Icons.person,
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
      ]),
    );
  }
}
