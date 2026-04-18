import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/animations/animations.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/routing/routes.dart';
import 'package:employee_mangement/core/style/app_colors.dart';
import 'package:employee_mangement/core/style/app_text_style.dart';
import 'package:flutter/material.dart';

class HomeHistoryHeader extends StatelessWidget {
  const HomeHistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedByWidgetType(
      widgetType: WidgetAnimationType.text,
      delayDuration: const Duration(milliseconds: 500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'History'.tr(context: context),
            style: AppTextStyle.title18,
          ),
          GestureDetector(
            onTap: () =>
                context.pushName(Routes.employeeAttendanceHistoryScreen),
            child: const Icon(
              Icons.arrow_forward_ios_outlined,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
