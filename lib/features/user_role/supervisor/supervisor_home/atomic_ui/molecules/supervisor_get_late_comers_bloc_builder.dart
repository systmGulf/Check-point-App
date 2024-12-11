import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../contoller/Supervisor_get_employee_attendance/supervisor_get_employee_attendance_cubit.dart';
import '../organism/employee_attendace.dart';

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
            itemCount: state.employeeAllAttendance.data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: EmployeeAttendance(
                  totalHours:
                      state.employeeAllAttendance.data![index].totalHours.toString(),
                  id: state.employeeAllAttendance.data![index].id.toString(),
                  employeeName:
                      state.employeeAllAttendance.data![index].employeeName ?? '',
                  location: state.employeeAllAttendance.data![index].area ?? '',
                  inTime: state.employeeAllAttendance.data![index].clockInTime ?? '',
                  outTime:
                      state.employeeAllAttendance.data![index].clockOutTime ?? '',
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
          return Skeletonizer(
              child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.only(top: 10),
                child: EmployeeAttendance(
                  totalHours: '10:00',
                  id: '',
                  employeeName: 'data loading',
                  location: 'data loading',
                  inTime: '10:00',
                  outTime: '10:00',
                ),
              );
            },
          ));
        } else {
          return Container();
        }
      },
    );
  }
}
