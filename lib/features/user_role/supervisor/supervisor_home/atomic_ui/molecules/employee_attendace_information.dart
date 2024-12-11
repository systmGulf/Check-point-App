import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class EmployeeAttendanceInformation extends StatelessWidget {
  const EmployeeAttendanceInformation({
    super.key,
    required this.text,
    required this.days,
  });
  final String text, days;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text, style: AppStylesManger.font18RegulerBlack),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
              color: ColorsManger.primaryColor,
              borderRadius: BorderRadius.circular(5.r)),
          child: Container(
              height: 28.h,
              width: 114.w,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.r)),
              child: Center(
                child: Text(
                  days,
                  style: AppStylesManger.font14RegularBlack,
                ),
              )),
        )
      ],
    );
  }
}
