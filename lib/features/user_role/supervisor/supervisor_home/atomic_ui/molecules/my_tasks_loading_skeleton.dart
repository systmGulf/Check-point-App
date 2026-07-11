import 'package:flutter/material.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_tasks_reponse_model/employee_tasks_response_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../atoms/taks_card.dart';

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
          return TaskCard(
            task: EmployeeTasks(),
          );
        },
      ),
    );
  }
}
