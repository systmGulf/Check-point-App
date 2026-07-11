import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/common/app_container_decoration.dart';
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

  // final List<GetEmployeesForTheTask> employeeName;
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
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: AppContainerDecoration().copyWith(
        border: Border.all(
          color: const Color(0xFFE8D9D9),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TaskMenuButton(
                    onEdit: widget.onEdit,
                    onDelete: widget.onDelete,
                  ),
                  SizedBox(height: 10.h),
                  _TaskStatusChip(status: localizedStatus),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 54.h,
                          width: 54.w,
                          child: Image.asset(
                            'assets/images/pngwing.com.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: AppStylesManger.font16BoldBlack,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                widget.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style:
                                    AppStylesManger.font15RegularGrey.copyWith(
                                  color: const Color(0xFF8B8B94),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: _TaskPriorityRow(
                                  priority: localizedPriority,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Text(
                          _formatDate(widget.date),
                          style: AppStylesManger.font12RegularGrey,
                        ),
                        const Spacer(),
                        Text(
                          '${'Assigned to'.tr()} (${widget.employeeName.length})',
                          textAlign: TextAlign.end,
                          style: AppStylesManger.font15BoldBlack.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        const Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Divider(
            thickness: 1,
            height: 1,
            color: const Color(0xFFE7D6D6),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                _TaskStatusMenu(
                  onSelected: widget.onSelected,
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Column(
                children: List.generate(
                  widget.employeeName.length,
                  (index) => EmployeeAssignedWidget(
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
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
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
            color: ColorsManger.primaryColor.withValues(alpha: 0.2),
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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        status,
        style: AppStylesManger.font11RegularGrey.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          priority,
          style: AppStylesManger.font12RegularBlack.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 4.w),
        Icon(
          Icons.outlined_flag,
          size: 18.sp,
          color: color,
        ),
      ],
    );
  }
}
