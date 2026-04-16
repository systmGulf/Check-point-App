import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyTasksLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const MyTasksLoadingSkeleton({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          Container(
            child: Column(
              children: [
                Text("data loading"),
              ],
            ),
          );
        },
      ),
    );
  }
}
