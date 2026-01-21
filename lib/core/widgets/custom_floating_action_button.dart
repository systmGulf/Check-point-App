import 'package:employee_mangement/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/app_spaces.dart';
import '../styles/styles.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton(
      {super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Container(
            height: 55.h,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
                color: ColorsManger.primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: ColorsManger.primaryColor,
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(16.r)),
            child: Row(children: [
              Icon(
                Icons.add,
                color: Colors.white,
                size: 20.sp,
              ),
              horizontalSpace(5.w),
              Text(text,
                  style: AppStylesManger.font14regularWhite
                      .copyWith(fontWeight: FontWeight.bold))
            ])),
      ),
    );
  }
}
