import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../atoms/client_item.dart';

class ClientsLoadingSkeleton extends StatelessWidget {
  const ClientsLoadingSkeleton({super.key, this.count = 10});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        count,
        (index) => Skeletonizer(
          child: ClientItem(
            onTap: () {},
            onEdit: () {},
            color: Colors.white,
            id: '',
            name: 'Load Data',
            workedAs: 'Load Data',
            location: 'Load Data',
          ),
        ),
      ),
    );
  }
}
