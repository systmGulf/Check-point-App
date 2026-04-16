import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/no_data_found_animation_widget.dart';
import '../../../../employee/employee_home/controller/tasks/tasks_cubit.dart';
import '../atoms/taks_card.dart';
import '../pages/my_tasks_loading_skeleton.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, 'Tasks'.tr()),
      body: SafeArea(
        child: BlocConsumer<EmployeeTasksCubit, EmployeeTasksState>(
          listener: (context, state) {
            if (state is DeleteEmployeeTaskError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          buildWhen: (previous, current) =>
              current is GetMyTasksLoading ||
              current is GetMyTasksSuccess ||
              current is GetMyTasksError ||
              current is DeleteEmployeeTaskLoading ||
              current is DeleteEmployeeTaskSuccess ||
              current is DeleteEmployeeTaskError,
          builder: (context, state) {
            if (state is GetMyTasksLoading ||
                state is DeleteEmployeeTaskLoading) {
              return const MyTasksLoadingSkeleton();
            }

            if (state is GetMyTasksError) {
              return Center(child: Text(state.error));
            }

            if (state is GetMyTasksSuccess) {
              if (state.getTaskResponse.isEmpty) {
                return NoDataFound();
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                itemCount: state.getTaskResponse.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final task = state.getTaskResponse[index];
                  return ElasticInUp(
                    child: Stack(
                      children: [
                        TaskCard(task: task),
                        PositionedDirectional(
                          top: 8,
                          end: 8,
                          child: IconButton(
                            onPressed: () {
                              final employeeTaskId = task.id?.trim() ?? '';
                              if (employeeTaskId.isEmpty) return;
                              context
                                  .read<EmployeeTasksCubit>()
                                  .deleteTask(employeeTaskId: employeeTaskId);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            if (state is DeleteEmployeeTaskSuccess) {
              return const MyTasksLoadingSkeleton();
            }
            return const MyTasksLoadingSkeleton();
          },
        ),
      ),
    );
  }
}
