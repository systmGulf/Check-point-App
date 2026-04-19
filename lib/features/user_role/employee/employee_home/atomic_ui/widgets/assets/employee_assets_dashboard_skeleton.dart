import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EmployeeAssetsDashboardSkeleton extends StatelessWidget {
  const EmployeeAssetsDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.5,
            children: List<Widget>.generate(
              4,
              (_) => Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 10),
                    SizedBox(height: 8),
                    Text('0000', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 4),
                    Text('Loading'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'My Asset Requests',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...List<Widget>.generate(
            3,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Asset name'),
                    SizedBox(height: 8),
                    Text('Asset note placeholder line one'),
                    SizedBox(height: 6),
                    Text('Requested at: 2026-01-01'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
