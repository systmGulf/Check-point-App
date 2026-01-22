import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../contoller/tasks_cubit/tasks_cubit.dart';
import '../atoms/task_item.dart';

class SupervisorTasksLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const SupervisorTasksLoadingSkeleton({
    super.key,
    this.itemCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (_, __) => TaskItem(
          employeeName: [],
          onSelected: (value) {},
          onEdit: () {},
          onDelete: () {},
          tasks: context.read<TasksCubit>().tasks,
          id: '1',
          priority: 'Loading...',
          state: 'Loading...',
          title: 'Loading...',
          description: 'Loading...',
          date: '2023-12-12',
        ),
      ),
    );
  }
}
