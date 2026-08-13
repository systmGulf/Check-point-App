import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/employee_assigned_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/task_model/get_task_response.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../contoller/tasks_cubit/tasks_cubit.dart';

class TaskItem extends StatefulWidget {
  const TaskItem(
      {super.key,
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
      required this.employeeName});
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFEFEFEF),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Status Badge & More Options button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TaskStatusChip(status: localizedStatus),
              Row(
                children: [
                  _TaskPriorityRow(priority: localizedPriority),
                  SizedBox(width: 8.w),
                  _TaskMenuButton(
                    onEdit: widget.onEdit,
                    onDelete: widget.onDelete,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Title & Description
          Text(
            widget.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStylesManger.font16BoldBlack.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            widget.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppStylesManger.font15RegularGrey.copyWith(
              color: const Color(0xFF6B7280),
              fontSize: 13.sp,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16.h),

          // Divider
          Container(
            height: 1,
            color: const Color(0xFFF3F4F6),
          ),
          SizedBox(height: 12.h),

          // Footer Row: Due Date & Employee count & Expand/Collapse toggle & Change status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Due Date info
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    _formatDate(widget.date),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // Assignee indicator & action
              Row(
                children: [
                  _TaskStatusMenu(onSelected: widget.onSelected),
                  SizedBox(width: 8.w),
                  Text(
                    '${'Assigned to'.tr()} (${widget.employeeName.length})',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          // Expandable Assignee List
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Column(
                children: List.generate(
                  widget.employeeName.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: EmployeeAssignedWidget(
                      onDelete: () {
                        context.read<TasksCubit>().deleteEmployeeFromTask(
                              taskId: int.parse(widget.id),
                              employeeIds:
                                  widget.employeeName[index].id.toString(),
                            );
                      },
                      departmentName:
                          widget.employeeName[index].departmentName ?? '',
                      name: widget.employeeName[index].userName ??
                          widget.employeeName[index].name ??
                          '',
                      imageUrl: widget.employeeName[index].branchName ?? '',
                      position: widget.employeeName[index].position ?? '',
                    ),
                  ),
                ),
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  String _formatDate(String value) {
    final parsedDate = DateTime.tryParse(value);
    if (parsedDate == null) {
      return value.length >= 10 ? value.substring(0, 10) : value;
    }
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }
}

class _TaskStatusMenu extends StatelessWidget {
  const _TaskStatusMenu({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      onSelected: onSelected,
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'InProgress',
          child: Text(
            'InProgress'.tr(),
            style: const TextStyle(color: Color(0xFF5F33E1)),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Done',
          child: Text(
            'Done'.tr(),
            style: const TextStyle(color: Color(0xFF0087FF)),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Pending',
          child: Text(
            'Pending'.tr(),
            style: const TextStyle(color: Color(0xFFE73C3C)),
          ),
        ),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: ColorsManger.primaryColor.withOpacity(0.2),
          ),
        ),
        child: Text(
          'Change status'.tr(),
          style: AppStylesManger.font12RegularBlack.copyWith(
            color: ColorsManger.primaryColor,
            fontWeight: FontWeight.w600,
          ),
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
        Icons.more_vert,
        color: Color(0xFF5C4B4B),
      ),
    );
  }
}

class _TaskStatusChip extends StatelessWidget {
  const _TaskStatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = status == 'InProgress'.tr()
        ? const Color(0xFFF0ECFF)
        : status == 'Done'.tr()
            ? const Color(0xFFE3F2FF)
            : const Color(0xFFFFE8F0);
    final textColor = status == 'InProgress'.tr()
        ? const Color(0xFF5F33E1)
        : status == 'Done'.tr()
            ? const Color(0xFF0087FF)
            : const Color(0xFFE73C3C);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status,
        style: AppStylesManger.font11RegularGrey.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}

class _TaskPriorityRow extends StatelessWidget {
  const _TaskPriorityRow({required this.priority});

  final String priority;

  @override
  Widget build(BuildContext context) {
    final color = priority == 'Low'.tr()
        ? const Color(0xFF0087FF)
        : priority == 'Medium'.tr()
            ? const Color(0xFF5F33E1)
            : const Color(0xFFE73C3C);

    final bg = priority == 'Low'.tr()
        ? const Color(0xFFE3F2FF)
        : priority == 'Medium'.tr()
            ? const Color(0xFFF0ECFF)
            : const Color(0xFFFFE8F0);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flag,
            size: 14.sp,
            color: color,
          ),
          SizedBox(width: 4.w),
          Text(
            priority,
            style: AppStylesManger.font12RegularBlack.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}
