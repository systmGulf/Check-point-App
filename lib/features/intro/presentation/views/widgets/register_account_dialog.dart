import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helpers/app_spaces.dart';
import '../../../../../core/helpers/extention.dart';
import '../../../../../core/styles/colors.dart';
import '../../../../../core/styles/styles.dart';
import '../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../cubit/register_account/register_account_cubit.dart';

class RegisterAccountDialog extends StatefulWidget {
  const RegisterAccountDialog({
    super.key,
  });

  @override
  State<RegisterAccountDialog> createState() => _RegisterAccountDialogState();
}

class _RegisterAccountDialogState extends State<RegisterAccountDialog> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Registere Account'.tr(),
          style: AppStylesManger.font15BoldBlack
              .copyWith(color: ColorsManger.primaryColor)),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ask Admin to Create Account'.tr(),
                style: AppStylesManger.font15BoldBlack
                    .copyWith(fontSize: 10.sp, color: Colors.grey)),
            verticalSpace(16),
            CustomAppTextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter your Name'.tr();
                  }
                  return null;
                },
                controller: _nameController,
                hint: 'Please Enter your Name'.tr())
          ],
        ),
      ),
      actions: [
        TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    side: const BorderSide(color: Colors.black))),
            onPressed: () {
              context.pop();
            },
            child: Text('Cancel'.tr(), style: AppStylesManger.font15BoldBlack)),
        TextButton(
            style: TextButton.styleFrom(
              backgroundColor: ColorsManger.primaryColor,
              elevation: 1,
              shadowColor: ColorsManger.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  side: BorderSide(color: ColorsManger.primaryColor)),
            ),
            onPressed: () {
              _validateAndRegister(context);
            },
            child: Text('Ok'.tr(),
                style: AppStylesManger.font15BoldBlack
                    .copyWith(color: Colors.white))),
      ],
    );
  }

  void _validateAndRegister(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterAccountCubit>().registerAccount(
            name: _nameController.text.trim(),
            deviceToken: '123',
          );
    }
  }
}
