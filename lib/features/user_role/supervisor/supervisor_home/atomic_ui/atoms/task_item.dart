import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/common/app_container_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/task_model/get_task_response.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../contoller/tasks_cubit/tasks_cubit.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.title,
    required this.description,
    required this.priority,
    required this.date,
    required this.state,
    required this.id,
    required this.tasks,
    required this.onDelete,
    required this.onEdit,
    required this.onSelected,
    required this.employeeName,
  });

  final String title, description, priority, date, state;
  final List<GetEmployeesForTheTask> employeeName;
  final String id;
  final List<GetTasData> tasks;
  final VoidCallback onDelete, onEdit;
  final ValueChanged<String> onSelected;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final localizedStatus = widget.state.tr();
    final localizedPriority = widget.priority.tr();

    // Map priority colors and label
    Color priorityColor = Colors.grey;
    String priorityLabel = widget.priority.tr();
    if (widget.priority.toLowerCase().contains('high') || widget.priority.contains('عالي')) {
      priorityColor = const Color(0xFFEF5350);
    } else if (widget.priority.toLowerCase().contains('med') || widget.priority.contains('متوسط')) {
      priorityColor = const Color(0xFF5F33E1);
    } else {
      priorityColor = const Color(0xFF0087FF);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Status Badge & Priority Flag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TaskStatusChip(status: localizedStatus),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    priorityLabel,
                    style: TextStyle(
                      color: priorityColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.outlined_flag,
                    color: priorityColor,
                    size: 16.sp,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Title & Description & Menu Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: const Color(0xFF1F2937),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.description,
                      style: TextStyle(
                        color: const Color(0xFF9CA3AF),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              _TaskMenuButton(
                onEdit: widget.onEdit,
                onDelete: widget.onDelete,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          const Divider(color: Color(0xFFF3F4F6), thickness: 1.2),
          SizedBox(height: 8.h),

          // Expandable Assignment row & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Assignment trigger
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: const Color(0xFF9CA3AF),
                      size: 20.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${'Assigned to'.tr()} (${widget.employeeName.length})',
                      style: TextStyle(
                        color: const Color(0xFF4B5563),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    _buildStackedAvatars(widget.employeeName),
                  ],
                ),
              ),
              // Right: Date
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatDate(widget.date),
                    style: TextStyle(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.calendar_today_rounded,
                    color: const Color(0xFF9CA3AF),
                    size: 16.sp,
                  ),
                ],
              ),
            ],
          ),

          // Expanded section: Employee details
          if (isExpanded) ...[
            SizedBox(height: 12.h),
            Column(
              children: List.generate(
                widget.employeeName.length,
                (index) => _buildEmployeeRow(widget.employeeName[index]),
              ),
            ),
          ],

          SizedBox(height: 12.h),

          // Change status Dropdown
          _TaskStatusMenu(
            onSelected: widget.onSelected,
            currentStatus: localizedStatus,
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeRow(GetEmployeesForTheTask employee) {
    final name = employee.userName ?? employee.name ?? '';
    final initials = name.isNotEmpty ? name.substring(0, 2).toUpperCase() : 'EE';
    final colors = [const Color(0xFF3B82F6), const Color(0xFFF59E0B), const Color(0xFFEF4444)];
    final bgColor = colors[employee.id.hashCode % colors.length];

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFF3F4F6), width: 1.0),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: const Color(0xFF1F2937),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  employee.position ?? 'Employee'.tr(),
                  style: TextStyle(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          // Department label
          Text(
            '${'القسم:'.tr()} ${employee.departmentName ?? ''}',
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: 12.sp,
            ),
          ),
          IconButton(
            onPressed: () {
              context.read<TasksCubit>().deleteEmployeeFromTask(
                    taskId: int.parse(widget.id),
                    employeeIds: employee.id.toString(),
                  );
            },
            icon: Icon(
              Icons.remove_circle_outline_rounded,
              color: Colors.red.shade400,
              size: 18.sp,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildStackedAvatars(List<GetEmployeesForTheTask> employees) {
    List<Widget> children = [];
    final displayCount = employees.length > 3 ? 3 : employees.length;

    for (int i = 0; i < displayCount; i++) {
      final emp = employees[i];
      final name = emp.userName ?? emp.name ?? '';
      final initials = name.isNotEmpty ? name.substring(0, 2).toUpperCase() : 'EE';
      final colors = [const Color(0xFF3B82F6), const Color(0xFFF59E0B), const Color(0xFFEF4444)];
      final bgColor = colors[emp.id.hashCode % colors.length];

      children.add(
        Positioned(
          left: i * 14.0,
          child: Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: (displayCount * 14.0 + 10.0).w,
      height: 24.w,
      child: Stack(
        children: children,
      ),
    );
  }

  String _formatDate(String value) {
    final parsedDate = DateTime.tryParse(value);
    if (parsedDate == null) {
      return value.length >= 10 ? value.substring(0, 10) : value;
    }
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }
}

class _TaskStatusMenu extends StatelessWidget {
  const _TaskStatusMenu({required this.onSelected, required this.currentStatus});

  final ValueChanged<String> onSelected;
  final String currentStatus;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      onSelected: onSelected,
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'InProgress',
          child: Text(
            'InProgress'.tr(),
            style: const TextStyle(color: Color(0xFF00ADEF)),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Done',
          child: Text(
            'Done'.tr(),
            style: const TextStyle(color: Color(0xFF2E7D32)),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Pending',
          child: Text(
            'Pending'.tr(),
            style: const TextStyle(color: Color(0xFFEF6C00)),
          ),
        ),
      ],
      child: Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Change status'.tr(),
              style: TextStyle(
                color: const Color(0xFF374151),
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: const Color(0xFF9CA3AF),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskMenuButton extends StatelessWidget {
  const _TaskMenuButton({
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      onSelected: (value) {
        if (value == 'edit') {
          onEdit();
        } else if (value == 'delete') {
          onDelete();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: Text('who will work on it'.tr()),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Text(
            'Delete'.tr(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
      child: const Icon(
        Icons.more_vert_rounded,
        color: Color(0xFF9CA3AF),
      ),
    );
  }
}

class _TaskStatusChip extends StatelessWidget {
  const _TaskStatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isDone = status == 'Done'.tr() || status.toLowerCase().contains('done') || status.contains('مكتمل');
    final isInProgress = status == 'InProgress'.tr() || status.toLowerCase().contains('progress') || status.contains('قيد');

    final backgroundColor = isDone
        ? const Color(0xFFE8F5E9)
        : isInProgress
            ? const Color(0xFFE3F2FD)
            : const Color(0xFFFFF3E0);

    final textColor = isDone
        ? const Color(0xFF2E7D32)
        : isInProgress
            ? const Color(0xFF1565C0)
            : const Color(0xFFEF6C00);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
