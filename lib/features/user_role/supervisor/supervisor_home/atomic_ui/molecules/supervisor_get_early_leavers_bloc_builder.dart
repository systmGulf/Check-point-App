import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import '../../contoller/Supervisor_get_employee_attendance/supervisor_get_employee_attendance_cubit.dart';
import '../organism/employee_attendace.dart';

class SupervisorGetEarlyLeaversBlocBuilder extends StatelessWidget {
  const SupervisorGetEarlyLeaversBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupervisorGetEmployeeAttendanceCubit,
        SupervisorGetEmployeeAttendanceState>(
      buildWhen: (previous, current) =>
          current is SupervisorGetEarlyLeaversFailure ||
          current is SupervisorGetEarlyLeaversSuccess ||
          current is SupervisorGetEarlyLeaversLoading,
      builder: (context, state) {
        if (state is SupervisorGetEarlyLeaversSuccess) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.employeeAllAttendance.data!.length,
            itemBuilder: (context, index) {
              return EmployeeAttendance(
                employeeId: state.employeeAllAttendance.data![index].employeeId.toString(),
                customerId: state.employeeAllAttendance.data![index].customerId.toString(), 
                totalHours:
                    state.employeeAllAttendance.data![index].totalHours.toString(),
                id: state.employeeAllAttendance.data![index].id.toString(),
                employeeName:
                    state.employeeAllAttendance.data![index].employeeName ?? '',
                location: state.employeeAllAttendance.data![index].location ?? '',
                inTime: state.employeeAllAttendance.data![index].clockInTime ?? '',
                outTime: state.employeeAllAttendance.data![index].clockOutTime ?? '',
              );
            },
          );
        } else if (state is SupervisorGetEarlyLeaversFailure) {
          return Center(
            child: Column(
              children: [
                const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                verticalSpace(10),
                Text(
                  state.errorMsg,
                  style: AppStylesManger.font14RedularRed,
                ),
              ],
            ),
          );
        } else if (state is SupervisorGetEarlyLeaversLoading) {
          return Skeletonizer(
              child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.only(top: 10),
                child: EmployeeAttendance(
                  employeeId: '',
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
