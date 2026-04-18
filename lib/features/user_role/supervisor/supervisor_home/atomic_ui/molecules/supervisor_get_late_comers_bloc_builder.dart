import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../contoller/Supervisor_get_employee_attendance/supervisor_get_employee_attendance_cubit.dart';
import '../organism/employee_attendace.dart';
import 'supervisor_late_comers_loading_skeleton.dart';

class SupervisorGetLateComersBlocBuilder extends StatelessWidget {
  const SupervisorGetLateComersBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupervisorGetEmployeeAttendanceCubit,
        SupervisorGetEmployeeAttendanceState>(
      buildWhen: (previous, current) =>
          current is SupervisorGetLateComersLoading ||
          current is SupervisorGetLateComersSuccess ||
          current is SupervisorGetLateComersFailure,
      builder: (context, state) {
        log(state.toString());
        if (state is SupervisorGetLateComersSuccess) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.employeeAllAttendance.value!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: EmployeeAttendance(
                    // isEarly: state.employeeAllAttendance.value![index].isEarly ??
                    //     false,
                    // isLate:
                    //     state.employeeAllAttendance.value![index].isLate ?? false,
                    // employeeId: state
                    //     .employeeAllAttendance.value![index].employeeId
                    //     .toString(),
                    // totalHours: state
                    //     .employeeAllAttendance.value![index].totalHours
                    //     .toString(),
                    // id: state.employeeAllAttendance.value![index].id.toString(),
                    // employeeName:
                    //     state.employeeAllAttendance.value![index].employeeName ??
                    //         '',
                    // location:
                    //     state.employeeAllAttendance.value![index].area ?? '',
                    // inTime:
                    //     state.employeeAllAttendance.value![index].clockInTime ??
                    //         '',
                    // outTime:
                    //     state.employeeAllAttendance.value![index].clockOutTime ??
                    //         '',
                    ),
              );
            },
          );
        } else if (state is SupervisorGetLateComersFailure) {
          return Column(
            children: [
              const Icon(Icons.error, color: Colors.red),
              const SizedBox(height: 10),
              Text(state.errorMsg),
            ],
          );
        } else if (state is SupervisorGetLateComersLoading) {
          return const SupervisorLateComersLoadingSkeleton();
        } else {
          return Container();
        }
      },
    );
  }
}
