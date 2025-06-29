import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class QuickActionsItem extends StatelessWidget {
  const QuickActionsItem({
    super.key,
    required this.icon,
    required this.text,
    required this.action,
  });
  final IconData icon;
  final String text;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        horizontalSpace(10),
        Text(
          text,
          style: AppStylesManger.font14RegularBlack,
        ),
        const Spacer(),
        CustomAppButton(
            width: 100.w,
            height: 35.h,
            textButton: 'Add'.tr(context: context),
            buttonColor: ColorsManger.primaryColor,
            onPressed: action),
        horizontalSpace(10),
      ],
    );
  }
}
