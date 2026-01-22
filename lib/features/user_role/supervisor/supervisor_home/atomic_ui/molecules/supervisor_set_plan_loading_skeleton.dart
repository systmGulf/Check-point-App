import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../atoms/plan_item.dart';

class SupervisorSetPlanLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const SupervisorSetPlanLoadingSkeleton({
    super.key,
    this.itemCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Skeletonizer(
          child: PlanItem(
            planId: 00,
            planDate: '2024-11-21T00:00:00',
            note: 'Data Load',
            onTap: () {},
          ),
        );
      },
    );
  }
}
