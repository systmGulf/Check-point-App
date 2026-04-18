import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppTextStyle {
  const AppTextStyle._();

  static TextStyle get title18 => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );

  static TextStyle get section15Bold => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      );

  static TextStyle get body12 => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get body12White => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      );
}
