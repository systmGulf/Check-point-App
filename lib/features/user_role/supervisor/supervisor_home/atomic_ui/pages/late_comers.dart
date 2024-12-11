import '../molecules/calender_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../contoller/Supervisor_get_employee_attendance/supervisor_get_employee_attendance_cubit.dart';
import '../molecules/supervisor_get_late_comers_bloc_builder.dart';

class LateComers extends StatelessWidget {
  const LateComers({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CalenderWidget(onTap: () {
            context
                .read<SupervisorGetEmployeeAttendanceCubit>()
                .supervisorGetLateComers();
          }),
          Divider(
            thickness: 1,
            color: Colors.grey[300],
          ),
          const SupervisorGetLateComersBlocBuilder()
        ],
      ),
    );
  }
}
