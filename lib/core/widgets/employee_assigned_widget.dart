import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/app_spaces.dart';

class EmployeeAssignedWidget extends StatelessWidget {
  const EmployeeAssignedWidget({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.position,
    required this.departmentName,
    this.onDelete,
  });
  final String name;
  final String imageUrl;
  final String position;
  final String departmentName;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            UserImage(
              imageUrl: imageUrl,
              height: 50,
            ),
            horizontalSpace(10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppStylesManger.font12RegularGrey
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 13.sp),
                ),
                Text(
                  position,
                  style: AppStylesManger.font12RegularGrey,
                ),
                Text(
                  "${"Department".tr(context: context)}: ${departmentName}",
                  style: AppStylesManger.font12RegularGrey,
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.delete,
                color: Colors.red,
                size: 20.sp,
              ),
            )
          ],
        ),
      ),
    );
  }
}
