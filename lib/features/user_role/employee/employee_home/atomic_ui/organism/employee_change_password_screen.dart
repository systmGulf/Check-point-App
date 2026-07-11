import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../controller/change_password/change_password_cubit.dart';
import 'employee_change_password_bloc_listener.dart';

class EmployeeChangePasswordScreen extends StatefulWidget {
  const EmployeeChangePasswordScreen({super.key});

  @override
  State<EmployeeChangePasswordScreen> createState() =>
      _EmployeeChangePasswordScreenState();
}

class _EmployeeChangePasswordScreenState
    extends State<EmployeeChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            buildCustomAppBar(context, 'Change Password'.tr()),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomAppTextFormField(
                    validator: (value) {
                      RegExp regex = RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (value!.isEmpty) {
                        return 'Please enter Old password'.tr();
                      } else {
                        if (!regex.hasMatch(value)) {
                          return 'Enter valid password'.tr();
                        } else {
                          return null;
                        }
                      }
                    },
                    controller: _oldPasswordController,
                    hint: 'Old Password'.tr()),
                verticalSpace(10),
                CustomAppTextFormField(
                    validator: (value) {
                      RegExp regex = RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (value!.isEmpty) {
                        return 'Please enter New password'.tr();
                      } else {
                        if (!regex.hasMatch(value)) {
                          return 'Enter valid  password'.tr();
                        } else {
                          return null;
                        }
                      }
                    },
                    controller: _newPasswordController,
                    hint: 'New Password'.tr()),
                verticalSpace(20),
                CustomAppButton(
                  textButton: 'Change Password'.tr(),
                  buttonColor: ColorsManger.primaryColor,
                  onPressed: () {
                    _validateAndChangePassword();
                  },
                ),
                const EmployeeChangePasswordBlocListener(),
              ],
            ),
          ),
        ));
  }

  void _validateAndChangePassword() {
    if (_formKey.currentState!.validate()) {
      context.read<EmployeeChangePasswordCubit>().changePassword(
            oldPassword: _oldPasswordController.text,
            newPassword: _newPasswordController.text,
          );
    }
  }
}
