import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
        fillColor: context
                    .read<TasksCubit>()
                    .priorityStatus
                    .tr(context: context) ==
                'medium'.tr(context: context)
            ? const Color(0xFFF0ECFF)
            : context.read<TasksCubit>().priorityStatus.tr(context: context) ==
                    'low'.tr(context: context)
                ? const Color(0xFFE3F2FF)
                : Color(0XFFFFE4F2),
        filled: true,
        prefixIcon: Icon(
          Icons.flag_outlined,
          color:
              context.read<TasksCubit>().priorityStatus.tr(context: context) ==
                      'medium'.tr(context: context)
                  ? const Color(0xFF5F33E1)
                  : context
                              .read<TasksCubit>()
                              .priorityStatus
                              .tr(context: context)
                              .tr(context: context) ==
                          'low'.tr(context: context)
                      ? const Color(0xFF0087FF)
                      : Colors.red,
        ),
        suffixIcon: SizedBox(
          width: 24,
          child: Center(
            child: SvgPicture.asset(
              'assets/images/arrow_down.svg',
              color: context
                          .read<TasksCubit>()
                          .priorityStatus
                          .tr(context: context) ==
                      'medium'.tr(context: context)
                  ? const Color(0xFF5F33E1)
                  : context
                              .read<TasksCubit>()
                              .priorityStatus
                              .tr(context: context) ==
                          'low'.tr(context: context)
                      ? const Color(0xFF0087FF)
                      : Colors.red,
            ),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      icon: const SizedBox(),
      initialValue: context.read<TasksCubit>().priorityStatus,
      style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color:
              context.read<TasksCubit>().priorityStatus.tr(context: context) ==
                      'medium'.tr(context: context)
                  ? const Color(0xFF5F33E1)
                  : context
                              .read<TasksCubit>()
                              .priorityStatus
                              .tr(context: context) ==
                          'low'.tr(context: context)
                      ? const Color(0xFF0087FF)
                      : Colors.red),
      items: [
        DropdownMenuItem(
          value: 'low',
          child: Text('low'.tr(context: context)),
        ),
        DropdownMenuItem(
          value: 'medium',
          child: Text('medium'.tr(context: context)),
        ),
        DropdownMenuItem(
          value: 'high',
          child: Text('high'.tr(context: context)),
        ),
      ],
      onChanged: widget.onChanged,
    );
  }
}
