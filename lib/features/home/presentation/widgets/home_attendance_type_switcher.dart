import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/style/app_colors.dart';
import 'package:employee_mangement/core/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slide_switcher/slide_switcher.dart';

class HomeAttendanceTypeSwitcher extends StatelessWidget {
  const HomeAttendanceTypeSwitcher({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final checkingText = [
      'Office'.tr(context: context),
      'Customer'.tr(context: context),
      'Site'.tr(context: context),
    ];

    return Directionality(
      textDirection: Directionality.of(context),
      child: SlideSwitcher(
        initialIndex: selectedIndex,
        onSelect: onSelect,
        containerColor: AppColors.primary,
        slidersBorder: Border.all(color: AppColors.primary),
        containerHeight: 40.h,
        containerWight: MediaQuery.sizeOf(context).width / 1.2,
        children: List.generate(
          checkingText.length,
          (index) => Text(
            checkingText[index],
            style: AppTextStyle.title18.copyWith(
              color:
                  selectedIndex == index ? AppColors.primary : AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
