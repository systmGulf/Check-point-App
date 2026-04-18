import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_tasks_reponse_model/employee_tasks_response_model.dart';

import '../../../../../../core/styles/styles.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.onStateTap,
  });

  final EmployeeTaskItem task;
  final VoidCallback? onStateTap;

  String _priorityText(int? value) {
    switch (value) {
      case 0:
        return 'Low';
      case 1:
        return 'Medium';
      case 2:
        return 'High';
      default:
        return '--';
    }
  }

  String _stateText(int? value) {
    switch (value) {
      case 0:
        return 'Pending';
      case 1:
        return 'InProgress';
      case 2:
        return 'Completed';
      case 3:
        return 'OnHold';
      case 4:
        return 'Cancelled';
      default:
        return '--';
    }
  }

  Color _priorityTextColor(int? value) {
    switch (value) {
      case 0:
        return Colors.green.shade700;
      case 1:
        return Colors.orange.shade700;
      case 2:
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  Color _priorityBgColor(int? value) {
    switch (value) {
      case 0:
        return Colors.green.shade50;
      case 1:
        return Colors.orange.shade50;
      case 2:
        return Colors.red.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _stateTextColor(int? value) {
    switch (value) {
      case 0:
        return Colors.orange.shade700;
      case 1:
        return Colors.blue.shade700;
      case 2:
        return Colors.green.shade700;
      case 3:
        return Colors.purple.shade700;
      case 4:
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  Color _stateBgColor(int? value) {
    switch (value) {
      case 0:
        return Colors.orange.shade50;
      case 1:
        return Colors.blue.shade50;
      case 2:
        return Colors.green.shade50;
      case 3:
        return Colors.purple.shade50;
      case 4:
        return Colors.red.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  String _formatDeadline(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) return '--';
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;
    return DateFormat('MMM d, yyyy').format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.taskTitle ?? '--',
            style: AppStylesManger.font16BoldBlack,
          ),
          const SizedBox(height: 6),
          // Text(
          //   '${'Code'.tr()}: ${task.taskCode ?? '--'}',
          //   style:
          //       AppStylesManger.font14RegularBlack.copyWith(color: Colors.grey),
          // ),
          // const SizedBox(height: 4),
          Text(
            '${'Code'.tr()}: ${task.taskCode ?? '--'}',
            style:
                AppStylesManger.font14RegularBlack.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            '${'Deadline'.tr()}: ${_formatDeadline(task.deadLine)}',
            style:
                AppStylesManger.font14RegularBlack.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                label: '${'Priority'.tr()}: ${_priorityText(task.priority)}',
                textColor: _priorityTextColor(task.priority),
                bgColor: _priorityBgColor(task.priority),
              ),
              GestureDetector(
                onTap: onStateTap,
                child: _InfoChip(
                  label: '${'State'.tr()}: ${_stateText(task.state)}',
                  textColor: _stateTextColor(task.state),
                  bgColor: _stateBgColor(task.state),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            task.taskDescription ?? '--',
            style:
                AppStylesManger.font14RegularBlack.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.textColor,
    required this.bgColor,
  });

  final String label;
  final Color textColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppStylesManger.font12RegularBlack.copyWith(color: textColor),
      ),
    );
  }
}
