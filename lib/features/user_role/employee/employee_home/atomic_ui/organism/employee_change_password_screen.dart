import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../controller/change_password/change_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/styles/colors.dart';
import 'employee_change_password_bloc_listener.dart';

class EmployeeChangePasswordScreen extends StatefulWidget {
  const EmployeeChangePasswordScreen({super.key});

  @override
  State<EmployeeChangePasswordScreen> createState() =>
      _EmployeeChangePasswordScreenState();
}

class _EmployeeChangePasswordScreenState
    extends State<EmployeeChangePasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  @override
  void initState() {
    oldPasswordController =
        BlocProvider.of<EmployeeChangePasswordCubit>(context)
            .oldPasswordController;
    newPasswordController =
        BlocProvider.of<EmployeeChangePasswordCubit>(context)
            .newPasswordController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            buildCustomAppBar(context, 'Change Password'.tr(context: context)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomAppTextFormField(
                    validator: (value) {
                      RegExp regex = RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (value!.isEmpty) {
                        return 'Please enter Old password'.tr(context: context);
                      } else {
                        if (!regex.hasMatch(value)) {
                          return 'Enter valid password'.tr(context: context);
                        } else {
                          return null;
                        }
                      }
                    },
                    controller: oldPasswordController,
                    hint: 'Old Password'.tr(context: context)),
                verticalSpace(10),
                CustomAppTextFormField(
                    validator: (value) {
                      RegExp regex = RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (value!.isEmpty) {
                        return 'Please enter New password'.tr(context: context);
                      } else {
                        if (!regex.hasMatch(value)) {
                          return 'Enter valid  password'.tr(context: context);
                        } else {
                          return null;
                        }
                      }
                    },
                    controller: newPasswordController,
                    hint: 'New Password'.tr(context: context)),
                verticalSpace(20),
                CustomAppButton(
                  textButton: 'Change Password'.tr(context: context),
                  buttonColor: ColorsManger.primaryColor,
                  onPressed: () {
                    validateAndChangePassword();
                  },
                ),
                const EmployeeChangePasswordBlocListener(),
              ],
            ),
          ),
        ));
  }

  validateAndChangePassword() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<EmployeeChangePasswordCubit>(context).changePassword();
    }
  }
}
