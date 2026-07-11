import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/animations/animations.dart';
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
    return AnimatedByWidgetType(
      widgetType: WidgetAnimationType.container,
      child: Row(
        children: [
          AnimatedIconWidget(
            icon: icon,
            color: ColorsManger.primaryColor,
            size: 24,
          ),
          horizontalSpace(10),
          AnimatedTextWidget(
            text: text,
            style: AppStylesManger.font14RegularBlack,
            textAlign: TextAlign.start,
          ),
          const Spacer(),
          AnimatedByWidgetType(
            widgetType: WidgetAnimationType.button,
            child: CustomAppButton(
              width: 100.w,
              height: 35.h,
              textButton: 'Add'.tr(),
              buttonColor: ColorsManger.primaryColor,
              onPressed: action,
            ),
          ),
          horizontalSpace(10),
        ],
      ),
    );
  }
}
