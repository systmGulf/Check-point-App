import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../atoms/leave_application_item.dart';

class RecentLeaveApplicationLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const RecentLeaveApplicationLoadingSkeleton({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: LeaveApplicationItem(
              name: 'loading data',
              from: '2024-01-01',
              to: '2024-01-05',
              userToken: 'loading data',
              id: "00",
              createdBy: 'loading data',
              status: 0,
              type: 'loading data',
              employeeId: 'loading data',
              reason: 'loading data',
            ),
          );
        },
      ),
    );
  }
}
