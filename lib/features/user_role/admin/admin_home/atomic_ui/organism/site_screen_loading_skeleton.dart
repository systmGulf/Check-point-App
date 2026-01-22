import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../atoms/sites_item.dart';

class SiteScreenLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const SiteScreenLoadingSkeleton({
    super.key,
    this.itemCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
            child: const SitesItem(
              id: '',
              name: 'data loading',
              descritption: 'data loading',
              location: 'data loading',
            ),
          );
        },
      ),
    );
  }
}
