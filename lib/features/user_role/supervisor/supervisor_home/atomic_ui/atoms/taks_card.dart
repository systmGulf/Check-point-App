import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/build_alart_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_tasks_reponse_model/employee_tasks_response_model.dart';

import '../../../../../../core/enums/task_status.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../employee/employee_home/controller/tasks/tasks_cubit.dart';
import '../molecules/delete_task_bloc_listener.dart';

class TaskCard extends StatelessWidget {
  final EmployeeTasks task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppConatinerDecoration(),
      padding: EdgeInsets.all(10.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskAvatar(task: task),
          horizontalSpace(10),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: TaskTitleDescription(task: task)),
                    Column(
                      children: [
                        TaskStatusMenu(task: task),
                        InkWell(
                          onTap: () {
                            buildDeleteAlertDialog(context,
                                message:
                                    'Are you sure you want to delete this Task?',
                                title: 'Delete Task', onYes: () {
                              context
                                  .read<EmployeeTasksCubit>()
                                  .deleteTask(taskId: task.id ?? 0);
                                  context.pop();
                            });
                         
                          },
                          child: SvgPicture.asset(
                              'assets/images/delete_icon.svg',
                              height: 15.h),
                        )
                      ],
                    ),
                  ],
                ),
                verticalSpace(10),
                TaskBottomRow(task: task),
                DeleteTaskBlocListener()
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class TaskAvatar extends StatelessWidget {
  final EmployeeTasks task;

  const TaskAvatar({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final image = task.employees?.isNotEmpty == true
        ? task.employees!.first.imageUrl
        : null;

    return Container(
      width: 50.w,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDCEAFF), Color(0xFFC7D2FE)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: image != null && image.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.grid_view_rounded, color: Colors.blue.shade600),
              ),
            )
          : Icon(Icons.grid_view_rounded, color: Colors.blue.shade600),
    );
  }
}

class TaskTitleDescription extends StatelessWidget {
  final EmployeeTasks task;

  const TaskTitleDescription({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.title ?? 'Untitled Task'.tr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        verticalSpace(4),
        Text(
          task.description ?? 'No description'.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey.shade500),
        ),
      ],
    );
  }
}

class TaskStatusMenu extends StatelessWidget {
  final EmployeeTasks task;

  const TaskStatusMenu({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      icon: Text(
        "Change Status".tr(),
        style: AppStylesManger.font12RegularGrey
            .copyWith(fontWeight: FontWeight.bold),
      ),
      onSelected: (newStatus) {
        context.read<EmployeeTasksCubit>().updateTaskStatus(
              taskId: task.id!,
              taskStatus: newStatus,
            );
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          // TaskStatus
          value: TaskStatus.Pending.name,
          child: Text(
            'Pending'.tr(),
            style: TextStyle(color: Colors.red.shade400),
          ),
        ),
        PopupMenuItem(
            value: TaskStatus.InProgress.name,
            child: Text(
              'In Progress'.tr(),
              style: TextStyle(color: Colors.blue.shade400),
            )),
        PopupMenuItem(
            value: TaskStatus.Done.name,
            child: Text(
              'Completed'.tr(),
              style: TextStyle(color: Colors.green.shade400),
            )),
      ],
    );
  }
}

class TaskBottomRow extends StatelessWidget {
  final EmployeeTasks task;

  const TaskBottomRow({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PriorityChip(priority: task.priorityStatus ?? 'medium'),
        horizontalSpace(8),
        StatusChip(status: task.status ?? 'pending'),
        const Spacer(),
        if (task.dueDate != null) TaskDueDate(date: task.dueDate!),
      ],
    );
  }
}

class PriorityChip extends StatelessWidget {
  final String priority;

  const PriorityChip({super.key, required this.priority});

  Map<String, dynamic> get config {
    final p = priority.toLowerCase();
    if (p.contains('low')) {
      return {
        'label': 'Low',
        'color': Colors.grey.shade600,
        'bg': Colors.grey.shade100,
      };
    } else if (p.contains('high')) {
      return {
        'label': 'High',
        'color': Colors.red.shade600,
        'bg': Colors.red.shade100,
      };
    }
    return {
      'label': 'Medium',
      'color': Colors.blue.shade600,
      'bg': Colors.blue.shade100,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config['bg'],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag, size: 12, color: config['color']),
          const SizedBox(width: 4),
          Text(
            config['label'].toString().tr(),
            style: TextStyle(color: config['color'], fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  Map<String, dynamic> get config {
    final s = status.toLowerCase();
    if (s.contains('pending')) {
      return {
        'label': 'Pending',
        'color': Colors.orange.shade600,
        'bg': Colors.orange.shade100,
        'border': Colors.orange.shade200,
      };
    } else if (s.contains('inprogress')) {
      return {
        'label': 'In Progress',
        'color': Colors.blue.shade600,
        'bg': Colors.blue.shade100,
        'border': Colors.blue.shade200,
      };
    }
    return {
      'label': 'Completed',
      'color': Colors.green.shade600,
      'bg': Colors.green.shade100,
      'border': Colors.green.shade200,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config['bg'],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: config['border']),
      ),
      child: Text(
        config['label'].toString().tr(),
        style: TextStyle(color: config['color'], fontSize: 12),
      ),
    );
  }
}

class TaskDueDate extends StatelessWidget {
  final String date;

  const TaskDueDate({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final d = DateTime.tryParse(date);

    return Row(
      children: [
        Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade400),
        const SizedBox(width: 4),
        Text(
          d != null ? '${d.month}/${d.day}/${d.year}' : date,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
        ),
      ],
    );
  }
}

BoxDecoration AppConatinerDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.grey.shade100),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
