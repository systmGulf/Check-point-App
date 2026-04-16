import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SupervisorTasksLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const SupervisorTasksLoadingSkeleton({
    super.key,
    this.itemCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 160,
                  height: 14,
                  child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.black12))),
              SizedBox(height: 8),
              SizedBox(
                  width: 120,
                  height: 12,
                  child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.black12))),
              SizedBox(height: 8),
              SizedBox(
                  width: 200,
                  height: 12,
                  child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.black12))),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                      width: 90,
                      height: 24,
                      child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.black12))),
                  SizedBox(width: 8),
                  SizedBox(
                      width: 110,
                      height: 24,
                      child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.black12))),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                  width: double.infinity,
                  height: 12,
                  child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.black12))),
            ],
          ),
        ),
      ),
    );
  }
}
