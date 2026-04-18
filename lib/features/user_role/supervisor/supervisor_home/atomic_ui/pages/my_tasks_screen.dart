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

  String _stateText(BuildContext context, int state) {
    switch (state) {
      case 0:
        return 'Pending'.tr(context: context);
      case 1:
        return 'InProgress'.tr(context: context);
      case 2:
        return 'Completed'.tr(context: context);
      case 3:
        return 'OnHold'.tr(context: context);
      case 4:
        return 'Cancelled'.tr(context: context);
      default:
        return '--';
    }
  }

  Future<void> _showUpdateStateMenu(
      BuildContext context, String employeeTaskId) async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (index) => ListTile(
              title: Text(_stateText(context, index)),
              onTap: () => Navigator.of(ctx).pop(index),
            ),
          ),
        ),
      ),
    );
    if (selected == null) return;
    context.read<EmployeeTasksCubit>().updateTaskStatus(
          employeeTaskId: employeeTaskId,
          state: selected,
        );
  }

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
            if (state is UpdateTaskStatusError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
            if (state is UpdateTaskStatusSuccess) {}
          },
          buildWhen: (previous, current) =>
              current is GetMyTasksLoading ||
              current is GetMyTasksSuccess ||
              current is GetMyTasksError ||
              current is DeleteEmployeeTaskLoading ||
              current is DeleteEmployeeTaskSuccess ||
              current is DeleteEmployeeTaskError ||
              current is UpdateTaskStatusLoading ||
              current is UpdateTaskStatusSuccess ||
              current is UpdateTaskStatusError,
          builder: (context, state) {
            if (state is GetMyTasksLoading ||
                state is DeleteEmployeeTaskLoading ||
                state is UpdateTaskStatusLoading) {
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
                          child: PopupMenuButton<String>(
                            color: Colors.white,
                            onSelected: (value) {
                              final employeeTaskId = task.id?.trim() ?? '';
                              if (employeeTaskId.isEmpty) return;
                              if (value == 'update') {
                                _showUpdateStateMenu(context, employeeTaskId);
                              } else if (value == 'delete') {
                                context
                                    .read<EmployeeTasksCubit>()
                                    .deleteTask(employeeTaskId: employeeTaskId);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem<String>(
                                value: 'update',
                                child: Text('Update State'.tr()),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete'.tr()),
                              ),
                            ],
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.black87,
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
