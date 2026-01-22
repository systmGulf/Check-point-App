import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../atoms/departments_item.dart';

class DepartmentLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const DepartmentLoadingSkeleton({
    super.key,
    this.itemCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Skeletonizer(
          child: DepartmentItem(
            departmentId: 00,
            onTap: () {},
            departmentName: 'Loading...',
          ),
        );
      },
    );
  }
}
