import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/app_spaces.dart';

class SupervisorProfileLoadingSkeleton extends StatelessWidget {
  const SupervisorProfileLoadingSkeleton({
    super.key,
    required this.selectedIndex,
  });

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xffE5E7EB)),
        ),
        child: selectedIndex == 0
            ? const _SummarySkeletonBody()
            : const _DetailsSkeletonBody(),
      ),
    );
  }
}

class _SummarySkeletonBody extends StatelessWidget {
  const _SummarySkeletonBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 86,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        verticalSpace(12),
        const CircleAvatar(radius: 36),
        verticalSpace(12),
        const Text('Employee Full Name'),
        verticalSpace(6),
        const Text('Employee Arabic Name'),
        verticalSpace(6),
        const Text('EMP-0000'),
        verticalSpace(12),
        Row(
          children: const [
            Expanded(child: Chip(label: Text('Exp 0+'))),
            SizedBox(width: 8),
            Expanded(child: Chip(label: Text('Full Time'))),
          ],
        ),
        verticalSpace(12),
        const Divider(height: 1),
        verticalSpace(10),
        const _LinePlaceholder(),
        verticalSpace(8),
        const _LinePlaceholder(),
        verticalSpace(8),
        const _LinePlaceholder(),
      ],
    );
  }
}

class _DetailsSkeletonBody extends StatelessWidget {
  const _DetailsSkeletonBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Section Title'),
        SizedBox(height: 12),
        Divider(height: 1),
        SizedBox(height: 12),
        _LinePlaceholder(),
        SizedBox(height: 10),
        _LinePlaceholder(),
        SizedBox(height: 10),
        _LinePlaceholder(),
        SizedBox(height: 10),
        _LinePlaceholder(),
        SizedBox(height: 10),
        _LinePlaceholder(),
      ],
    );
  }
}

class _LinePlaceholder extends StatelessWidget {
  const _LinePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
