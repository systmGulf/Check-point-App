import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/colors.dart';
import '../styles/styles.dart';

class CustomAppButton extends StatelessWidget {
  const CustomAppButton(
      {super.key,
      required this.textButton,
      required this.buttonColor,
      this.border,
      this.onPressed,
      this.height,
      this.width});
  final String textButton;
  final Color? buttonColor;
  final double? border;
  final void Function()? onPressed;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(border ?? 0),
        width: width ?? double.infinity,
        height: height ?? 51.h,
        decoration: BoxDecoration(
            color: buttonColor ?? ColorsManger.lighorage,
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  ColorsManger.primaryColor,
                  const Color.fromARGB(255, 150, 144, 144),
                ]),
            borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
            textButton,
            style: AppStylesManger.font19reguleWhite
                .copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
        ),
      ),
    );
  }
}
