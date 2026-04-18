import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import '../../contoller/Supervisor_get_employee_attendance/supervisor_get_employee_attendance_cubit.dart';
import '../organism/employee_attendace.dart';
import 'supervisor_early_leavers_loading_skeleton.dart';

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
            itemCount: state.employeeAllAttendance.value!.length,
            itemBuilder: (context, index) {
              return EmployeeAttendance(
                // isEarly: state.employeeAllAttendance.value![index]
                //         .isEarly ??
                //     false,
                // isLate: state.employeeAllAttendance.value![index]
                //         .isLate ??
                //     false,
                // employeeId: state
                //     .employeeAllAttendance.value![index].employeeId
                //     .toString(),
                // customerId: state
                //     .employeeAllAttendance.value![index].customerId
                //     .toString(),
                // totalHours: state
                //     .employeeAllAttendance.value![index].totalHours
                //     .toString(),
                // id: state.employeeAllAttendance.value![index].id
                //     .toString(),
                employeeName: state.employeeAllAttendance.value![index]
                        .attendeeData?.name ??
                    '',
                // location: state.employeeAllAttendance.value![index]
                //         .location ??
                //     '',
                // inTime: state.employeeAllAttendance.value![index]
                //         .clockInTime ??
                //     '',
                // outTime: state.employeeAllAttendance.value![index]
                //         .clockOutTime ??
                //     '',
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
          return const SupervisorEarlyLeaversLoadingSkeleton();
        } else {
          return Container();
        }
      },
    );
  }
}
