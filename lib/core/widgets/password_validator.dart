import 'package:easy_localization/easy_localization.dart';
import '../styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../helpers/app_spaces.dart';

class PasswordValidation extends StatelessWidget {
  final bool hasLowerCase;
  final bool hasUpperCase;
  final bool hasNumber;
  final bool hasSpecialCharacter;
  final bool hasMinLength;
  const PasswordValidation(
      {super.key,
      required this.hasLowerCase,
      required this.hasUpperCase,
      required this.hasNumber,
      required this.hasSpecialCharacter,
      required this.hasMinLength});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      buildValidationRow('Must have at least 1 lowercase'.tr(), hasLowerCase),
      verticalSpace(8),
      buildValidationRow('Must have at least 1 number'.tr(), hasNumber),
      verticalSpace(8),
      buildValidationRow('Must have at least 1 uppercase'.tr(), hasUpperCase),
      verticalSpace(8),
      buildValidationRow(
          'Must have at least 1 special character'.tr(), hasSpecialCharacter),
      verticalSpace(8),
      buildValidationRow('at least 8 characters'.tr(), hasMinLength),
      verticalSpace(8),
    ]);
  }

  Widget buildValidationRow(String text, bool hasValidated) {
    return Row(
      children: [
        CircleAvatar(radius: 2.5.r, backgroundColor: Colors.grey),
        horizontalSpace(6),
        Text(
          text,
          style: AppStylesManger.font13DarkBlueMedium.copyWith(
              decoration: hasValidated ? TextDecoration.lineThrough : null,
              height: 1.5,
              decorationColor: Colors.green,
              decorationThickness: 2,
              color: hasValidated ? Colors.grey : Colors.black45),
        )
      ],
    );
  }
}
