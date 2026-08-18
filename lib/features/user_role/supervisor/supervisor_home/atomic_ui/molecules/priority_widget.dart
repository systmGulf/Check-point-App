import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../contoller/tasks_cubit/tasks_cubit.dart';

class priorityWidget extends StatefulWidget {
  const priorityWidget({
    super.key,
    required this.onChanged,
    this.prioity,
  });
  final ValueChanged<String?> onChanged;
  final String? prioity;

  @override
  State<priorityWidget> createState() => _priorityWidgetState();
}

class _priorityWidgetState extends State<priorityWidget> {
  late String selectedPriority;

  @override
  void initState() {
    super.initState();
    selectedPriority = widget.prioity ?? context.read<TasksCubit>().priorityStatus;
    if (selectedPriority.isEmpty) {
      selectedPriority = 'low';
    }
  }

  void _selectPriority(String val) {
    setState(() {
      selectedPriority = val;
    });
    widget.onChanged(val);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Low Priority
        Expanded(
          child: _buildPriorityButton(
            value: 'low',
            label: 'low'.tr(),
            activeBgColor: const Color(0xFF2E7D32),
            inactiveBgColor: const Color(0xFFE8F5E9),
            activeTextColor: Colors.white,
            inactiveTextColor: const Color(0xFF2E7D32),
          ),
        ),
        SizedBox(width: 12.w),
        // Medium Priority
        Expanded(
          child: _buildPriorityButton(
            value: 'medium',
            label: 'medium'.tr(),
            activeBgColor: const Color(0xFFEF6C00),
            inactiveBgColor: const Color(0xFFFFF3E0),
            activeTextColor: Colors.white,
            inactiveTextColor: const Color(0xFFEF6C00),
          ),
        ),
        SizedBox(width: 12.w),
        // High Priority
        Expanded(
          child: _buildPriorityButton(
            value: 'high',
            label: 'high'.tr(),
            activeBgColor: const Color(0xFFE73C3C),
            inactiveBgColor: const Color(0xFFFFE8F0),
            activeTextColor: Colors.white,
            inactiveTextColor: const Color(0xFFE73C3C),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityButton({
    required String value,
    required String label,
    required Color activeBgColor,
    required Color inactiveBgColor,
    required Color activeTextColor,
    required Color inactiveTextColor,
  }) {
    final isActive = selectedPriority == value;

    return GestureDetector(
      onTap: () => _selectPriority(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 48.h,
        decoration: BoxDecoration(
          color: isActive ? activeBgColor : inactiveBgColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeBgColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeTextColor : inactiveTextColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(
              Icons.outlined_flag,
              color: isActive ? activeTextColor : inactiveTextColor,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}
