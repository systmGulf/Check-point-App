import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NewsLoadingSkeleton extends StatelessWidget {
  const NewsLoadingSkeleton({
    super.key,
    required this.onRefresh,
    this.itemCount = 5,
  });

  final Future<void> Function() onRefresh;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Skeletonizer(
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xffE5E7EB)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Loading title placeholder'),
                  SizedBox(height: 8),
                  Text('Loading first line of details placeholder.'),
                  SizedBox(height: 6),
                  Text('Loading second line of details placeholder.'),
                  SizedBox(height: 8),
                  Divider(height: 1),
                  SizedBox(height: 8),
                  Text('Loading metadata placeholder.'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
