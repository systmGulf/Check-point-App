import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helpers/app_spaces.dart';
import '../../../../../core/helpers/extention.dart';
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
  @override
  initState() {
    super.initState();
    context.read<RegisterAccountCubit>().nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Registere Account'.tr(),
          style: AppStylesManger.font15BoldBlack),
      content: Form(
        key: context.read<RegisterAccountCubit>().formKey,
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
                controller: context.read<RegisterAccountCubit>().nameController,
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
              backgroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  side: const BorderSide(color: Colors.black)),
            ),
            onPressed: () {
              validateAndRegister(context);
            },
            child: Text('Ok'.tr(),
                style: AppStylesManger.font15BoldBlack
                    .copyWith(color: Colors.white))),
      ],
    );
  }

  void validateAndRegister(BuildContext context) {
    if (context.read<RegisterAccountCubit>().formKey.currentState!.validate()) {
      context.read<RegisterAccountCubit>().registerAccount();
    }
  }
}
