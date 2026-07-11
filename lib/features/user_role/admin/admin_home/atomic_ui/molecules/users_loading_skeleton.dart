import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../organism/user_item_load.dart';

class UsersLoadingSkeleton extends StatelessWidget {
  const UsersLoadingSkeleton({super.key, this.count = 10});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index < count - 1 ? 10 : 0),
          child: const UserItemLoad(),
        ),
      ),
    );
  }
}
