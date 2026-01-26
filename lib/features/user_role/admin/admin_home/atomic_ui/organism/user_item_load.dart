import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../atoms/user_item_list_view.dart';

class UserItemLoad extends StatelessWidget {
  final int itemCount;

  const UserItemLoad({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: UserItemListView(
          userId: ' ',
          userName: 'data loading',
          department: 'data loading',
          mobileId: 'data loading',
          role: 'data loading',
          departmentId: 00,
          branch: 'data loading',
          branchId: 00,
          imageUrl: 'data loading',
          shiftName: 'data loading',
          shiftEndTime: 'data loading',
          shiftStartTime: 'data loading',
          name: 'data loading',
          position: 'data loading',
          onDelete: () {},
        ),
      ),
    );
  }
}
