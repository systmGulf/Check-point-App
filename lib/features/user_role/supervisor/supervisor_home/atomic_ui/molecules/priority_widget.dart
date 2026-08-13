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
  @override
  Widget build(BuildContext context) {
    final currentPriority = context.watch<TasksCubit>().priorityStatus;

    final priorities = [
      {
        'value': 'low',
        'label': 'Low'.tr(),
        'color': const Color(0xFF0087FF),
        'bg': const Color(0xFFE3F2FF),
      },
      {
        'value': 'medium',
        'label': 'Medium'.tr(),
        'color': const Color(0xFF5F33E1),
        'bg': const Color(0xFFF0ECFF),
      },
      {
        'value': 'high',
        'label': 'High'.tr(),
        'color': const Color(0xFFE73C3C),
        'bg': const Color(0xFFFFE8F0),
      },
    ];

    return Row(
      children: priorities.map((p) {
        final isSelected = currentPriority == p['value'];
        final color = p['color'] as Color;
        final bg = p['bg'] as Color;
        final label = p['label'] as String;
        final value = p['value'] as String;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              onTap: () {
                widget.onChanged(value);
              },
              borderRadius: BorderRadius.circular(12.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected ? bg : Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected ? color : const Color(0xFFE8D9D9),
                    width: isSelected ? 2.0 : 1.2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSelected ? Icons.flag : Icons.flag_outlined,
                      color: isSelected ? color : const Color(0xFF8B8B94),
                      size: 20.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? color : const Color(0xFF5C4B4B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
