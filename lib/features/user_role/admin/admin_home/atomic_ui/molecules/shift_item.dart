import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';

class ShiftItem extends StatelessWidget {
  const ShiftItem({
    super.key,
    required this.shiftName, required this.onDelete, required this.onTap,
  });
  final String shiftName;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 80.h,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Container(
            height: 80.h,
            width: 80.w,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              'assets/images/work shift.png',
            ),
          ),
          horizontalSpace(10.w),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shiftName, style: AppStylesManger.font16BoldBlack)
              ]),
          Spacer(),
          IconButton(onPressed: onDelete , icon:    Icon(Icons.delete_outlined))
        ]),
      ),
    );
  }
}
