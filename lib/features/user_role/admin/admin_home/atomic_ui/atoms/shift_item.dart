import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class ShiftItem extends StatelessWidget {
  const ShiftItem({
    super.key,
    required this.shiftName, required this.onDelete, required this.onTap, required this.onAdd,
  });
  final String shiftName;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback onAdd;
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
          Icon(Icons.work, color: ColorsManger.primaryColor),
       
          horizontalSpace(10.w),
          
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shiftName, style: AppStylesManger.font15BoldBlack)
              ]),
          Spacer(),
          // InkWell(
          //   onTap: onAdd,
          //   child: CircleAvatar(
          //     radius: 16.r,
          //     backgroundColor: ColorsManger.primaryColor,
          //     child: Icon(Icons.add, color: Colors.white,),
          //     ),
          // ),
     
          IconButton(onPressed: onDelete , icon:    Icon(Icons.delete_outlined))
        ]),
      ),
    );
  }
}
