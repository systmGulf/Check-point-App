import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../atoms/shift_item.dart';

class ShiftLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const ShiftLoadingSkeleton({
    super.key,
    this.itemCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: ShiftItem(
              onAdd: () {},
              onTap: () {},
              onEdit: () {},
              onDelete: () {},
              shiftName: 'Data Loading',
            ),
          );
        },
      ),
    );
  }
}
