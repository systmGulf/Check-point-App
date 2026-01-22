import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../atoms/company_branch_item.dart';

class CompanyBranchLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const CompanyBranchLoadingSkeleton({
    super.key,
    this.itemCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: itemCount,
            (BuildContext context, int index) {
              return Skeletonizer(
                child: CompanyBranchItem(
                  onDelete: () {},
                  name: 'data Load',
                  location: 'data Load',
                  decoration: 'data Load',
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
