import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../contoller/Supervisor_get_employee_attendance/supervisor_get_employee_attendance_cubit.dart';

class CalenderWidget extends StatelessWidget {
  const CalenderWidget({super.key, required this.onTap});
  final VoidCallback onTap;
  static final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();

  @override
  Widget build(BuildContext context) {
    final currentLocale = EasyLocalization.of(context)!.locale;
    final currentLanguageCode = currentLocale.languageCode;
    return BlocBuilder<SupervisorGetEmployeeAttendanceCubit,
        SupervisorGetEmployeeAttendanceState>(
      builder: (context, state) {
        return Container(
          child: EasyInfiniteDateTimeLine(
            locale: currentLanguageCode,
            activeColor: ColorsManger.primaryColor,
            controller: _controller,
            firstDate: DateTime.now().subtract(const Duration(days: 30)),
            focusDate: state.selectedDate,
            lastDate: DateTime.now().add(const Duration(days: 60)),
            onDateChange: (selectedDate) {
              if (selectedDate != state.selectedDate) {
                context
                    .read<SupervisorGetEmployeeAttendanceCubit>()
                    .setSelectedDate(selectedDate);
                onTap();
              }
            },
          ),
        );
      },
    );
  }
}
