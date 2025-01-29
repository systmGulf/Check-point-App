import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/supervisor/data/models/employees_attendance_model/get_employee_attendance.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../contoller/Supervisor_get_employee_attendance/supervisor_get_employee_attendance_cubit.dart';
import '../../contoller/share_attendace_cubit/shareattendance_cubit.dart';
import '../organism/employee_attendace.dart';

class SupervisorGetAllEmployeesAttendanceBlocBuilder extends StatelessWidget {
  const SupervisorGetAllEmployeesAttendanceBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupervisorGetEmployeeAttendanceCubit,
        SupervisorGetEmployeeAttendanceState>(
      buildWhen: (previous, current) =>
          current is SupervisorGetEmployeeAttendanceLoading ||
          current is SupervisorGetEmployeeAttendanceFailure ||
          current is SupervisorGetEmployeeAttendanceSuccess,
      builder: (context, state) {
        if (state is SupervisorGetEmployeeAttendanceFailure) {
          return state.errorMsg == 'Please check your internet connection'
              ? NoInternetConnectionWidget(onPressed: () {
                  context
                      .read<SupervisorGetEmployeeAttendanceCubit>()
                      .supervisorGetEmployeesAttendanceByDepartmentId();
                })
              : Column(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    verticalSpace(20),
                    Text(state.errorMsg)
                  ],
                );
        } else if (state is SupervisorGetEmployeeAttendanceSuccess) {
          final List<SupervisorGetAllEmployeesAttendanceData> filteredList =
              state.employeeAllAttendance.data!
                  .where((attendance) =>
                      attendance.attendanceDate ==
                      state.selectedDate.toString().substring(0, 10))
                  .toList();
          return filteredList.isNotEmpty
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(children: [
                        Text(
                          'Share as Excel : '.tr(context: context),
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () async {
                              await Permission.storage.request();
                              context
                                  .read<ShareattendanceCubit>().exportAndShareExcel(
                                      filteredList);
                                
                            },
                            icon: Icon(
                              Icons.share,
                              size: 20.sp,
                              color: Colors.blue,
                            )),
                      ]),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: EmployeeAttendance(
                            employeeId: filteredList[index].employeeId ?? '',
                            customerId: filteredList[index].customerId.toString() ,
                            employeeImage: filteredList[index].employeeImage?? '',
                            totalHours:
                                filteredList[index].totalHours.toString() ,
                            id: filteredList[index].employeeId ?? '',
                            employeeName:
                                filteredList[index].employeeName ?? '',
                            location: filteredList[index].area ?? '',
                            inTime: filteredList[index].clockInTime ?? '',
                            outTime: filteredList[index].clockOutTime ?? '',
                          ),
                        );
                      },
                    ),
                  ],
                )
              : SizedBox(
                  height: 300.h,
                  child: NoDataFound());
        } else if (state is SupervisorGetEmployeeAttendanceLoading) {
          return Skeletonizer(
            enabled: true,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return  Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: EmployeeAttendance(
                    employeeId: '',
                    totalHours: double.parse( '0.12').toStringAsFixed(2),
                    id: '',
                    employeeName: 'data loading',
                    location: 'data loading',
                    inTime: '10:00',
                    outTime: '10:00',
                  ),
                );
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
