import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_tasks_reponse_model/employee_tasks_response_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../employee/employee_home/controller/tasks/tasks_cubit.dart';
import '../atoms/taks_card.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
     
      appBar: buildCustomAppBar(context, 'Tasks'.tr()),
      body: SafeArea(
        child: BlocBuilder<EmployeeTasksCubit, EmployeeTasksState>(
          bloc: context.read<EmployeeTasksCubit>(),
          buildWhen: (previous, current) => current is GetMyTasksLoading || current is GetMyTasksSuccess || current is GetMyTasksError,
          builder: (context, state) {
            if (state is GetMyTasksLoading) {
              Skeletonizer(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  itemCount: 5,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return TaskCard(
                      task: EmployeeTasks(),
                    );
                  },
                ),
              );
            }

            if (state is GetMyTasksError) {
              return Center(child: Text(state.error));
            }

            if (state is GetMyTasksSuccess) {
              if (state.getTaskResponse.isEmpty) {
                return buildEmptyState();
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                itemCount: state.getTaskResponse.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return TaskCard(
                    task: state.getTaskResponse[index],
                  );
                },
              );
            }
            return Skeletonizer(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return TaskCard(
                    task: EmployeeTasks(),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(48),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(
                Icons.task_alt,
                size: 32,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks yet'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first task to get started'.tr(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
