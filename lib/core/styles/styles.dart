import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class AppStylesManger {
  AppStylesManger._();

  // ============== Font Size 6 ==============
  static TextStyle font6BoldBlack = TextStyle(
    fontSize: 6.sp,
    fontWeight: FontWeight.bold,
    color: ColorsManger.lightblack,
  );

  // ============== Font Size 11 ==============
  static TextStyle font11RegularGrey = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManger.grey,
  );

  static TextStyle font11RegularBlack = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  // ============== Font Size 12 ==============
  static TextStyle font12RegularBlack = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static TextStyle font12RegularGrey = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6E6A7C),
  );

  // ============== Font Size 13 ==============
  static TextStyle font13RegularBlue = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.normal,
    color: ColorsManger.primaryColor,
  );

  // ============== Font Size 14 ==============
  static TextStyle font14RegularWhite = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  static TextStyle font14RegularBlack = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static TextStyle font14MediumBlack = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle font14BoldRed = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: ColorsManger.primaryColor,
  );

  static TextStyle font14BoldGreen = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: Colors.green,
  );

  // ============== Font Size 15 ==============
  static TextStyle font15RegularGrey = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.normal,
    color: ColorsManger.grey,
  );

  static TextStyle font15RegularPrimary = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.normal,
    color: ColorsManger.primaryColor,
  );

  static TextStyle font15BoldBlack = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.bold,
    color: ColorsManger.lightblack,
  );

  static TextStyle font15BoldBlue = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.bold,
    color: ColorsManger.primaryColor,
  );

  static TextStyle font15BoldRed = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.bold,
    color: ColorsManger.primaryColor,
  );

  // ============== Font Size 16 ==============
  static TextStyle font16RegularBlack = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static TextStyle font16RegularPrimary = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: ColorsManger.primaryColor,
  );

  static TextStyle font16MediumBlack = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle font16BoldBlack = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle font16BoldWhite = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle font16BoldPrimary = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: ColorsManger.primaryColor,
  );

  // ============== Font Size 18 ==============
  static TextStyle font18RegularBlack = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.normal,
    color: ColorsManger.lightblack,
  );

  static TextStyle font18RegularRed = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.normal,
    color: ColorsManger.primaryColor,
  );

  static TextStyle font18RegularGreen = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.normal,
    color: Colors.green,
  );

  static TextStyle font18SemiBoldBlack = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle font18BoldBlack = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // ============== Font Size 19 ==============
  static TextStyle font19RegularWhite = TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  static TextStyle font19RegularGrey = TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.normal,
    color: ColorsManger.grey,
  );

  static TextStyle font19RegularRed = TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.normal,
    color: ColorsManger.primaryColor,
  );

  static TextStyle font19RegularGreen = TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.normal,
    color: Colors.green,
  );

  // ============== Font Size 20 ==============
  static TextStyle font20MediumBlack = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle font20SemiBoldBlack = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  // ============== Font Size 21 ==============
  static TextStyle font21RegularWhite = TextStyle(
    fontSize: 21.sp,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  // ============== Font Size 24 ==============
  static TextStyle font24RegularBlack = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  // ============== Font Size 26 ==============
  static TextStyle font26RegularBlack = TextStyle(
    fontSize: 26.sp,
    fontWeight: FontWeight.normal,
    color: ColorsManger.lightblack,
  );

  static TextStyle font26BoldWhite = TextStyle(
    fontSize: 26.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // ============== Font Size 38 ==============
  static TextStyle font38BoldBlack = TextStyle(
    fontSize: 38.sp,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle get font19reguleWhite => font19RegularWhite;
  static TextStyle get font13regulerBlue => font13RegularBlue;
  static TextStyle get font13DarkBlueMedium => font11RegularBlack;
  static TextStyle get font18RedularGreen => font18RegularGreen;
  static TextStyle get font14Medium => font14MediumBlack;
  static TextStyle get font14regularWhite => font14RegularWhite;
  static TextStyle get font15BoldrBlue => font15BoldBlue;
  static TextStyle get font19regulerGrey => font19RegularGrey;
  static TextStyle get font19reguleRed => font19RegularRed;
  static TextStyle get font15regulerGrey => font15RegularGrey;
  static TextStyle get font24regularBlack => font24RegularBlack;
  static TextStyle get font24regulerBlack => font24RegularBlack;
  static TextStyle get font15regulerPrimaryColor => font15RegularPrimary;
  static TextStyle get font21regulerWhite => font21RegularWhite;
  static TextStyle get font18RegulerBlack => font18RegularBlack;
  static TextStyle get font18regulerRed => font18RegularRed;

  static TextStyle get font16regulerPrimaryColor => font16RegularPrimary;
  static TextStyle get font16regulerBlack => font16RegularBlack;
  static TextStyle get font26regulerBlack => font26RegularBlack;
  static TextStyle get font24boldWhite => font26BoldWhite;
  static TextStyle get font20semiBoldBlack => font20SemiBoldBlack;
  static TextStyle get font14RedularRed => font14BoldRed;
  static TextStyle get font14RedularGreen => font14BoldGreen;
  static TextStyle get font11clamgrey400weight => font11RegularGrey;
  static TextStyle get font16blackMedium => font16MediumBlack;
  static TextStyle get font20Medium => font20MediumBlack;
  static TextStyle get font18SemiBold => font18SemiBoldBlack;
}
