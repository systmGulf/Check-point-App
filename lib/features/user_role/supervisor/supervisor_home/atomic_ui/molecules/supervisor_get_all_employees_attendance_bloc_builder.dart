import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employees_attendance_model/get_employee_attendance.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../contoller/Supervisor_get_employee_attendance/supervisor_get_employee_attendance_cubit.dart';
import '../../contoller/share_attendace_cubit/shareattendance_cubit.dart';
import '../organism/employee_attendace.dart';
import 'supervisor_employees_attendance_loading_skeleton.dart';

class SupervisorGetAllEmployeesAttendanceBlocBuilder extends StatefulWidget {
  const SupervisorGetAllEmployeesAttendanceBlocBuilder({super.key});

  @override
  State<SupervisorGetAllEmployeesAttendanceBlocBuilder> createState() =>
      _SupervisorGetAllEmployeesAttendanceBlocBuilderState();
}

class _SupervisorGetAllEmployeesAttendanceBlocBuilderState
    extends State<SupervisorGetAllEmployeesAttendanceBlocBuilder> {
  initState() {
    context
        .read<SupervisorGetEmployeeAttendanceCubit>()
        .supervisorGetEmployeesAttendanceByDepartmentId();
    super.initState();
  }

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
          final allAttendance =
              state.employeeAllAttendance.value ?? <AttendanceItem>[];
          final List<AttendanceItem> filteredList = allAttendance
              .where(
                (attendance) =>
                    _matchesSelectedDate(attendance, state.selectedDate),
              )
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
                                  .read<ShareattendanceCubit>()
                                  .exportAndShareExcel(filteredList);
                            },
                            icon: Icon(
                              Icons.share,
                              size: 20.sp,
                              color: Colors.blue,
                            )),
                      ]),
                    ),
                    FadeInUp(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: EmployeeAttendance(
                              // feedbacks: filteredList[index]
                              //     .customerPlans!
                              //     .expand((plan) => plan.feedbacks ?? [])
                              //     .cast<FeedbackModel>()
                              //     .toList(),
                              // isEarly: filteredList[index].isEarly ?? false,
                              // isLate: filteredList[index].isLate ?? false,
                              // employeeId: filteredList[index].employeeId ?? '',
                              // customerId:
                              //     filteredList[index].customerId.toString(),
                              // employeeImage: filteredList[index].employeeImage,
                              // totalHours:
                              //     filteredList[index].totalHours.toString(),
                              // id: filteredList[index].employeeId ?? '',
                              employeeName: item.attendeeData?.name ?? '',
                              // location: filteredList[index].area ?? '',
                              inTime: item.checkIn ?? '',
                              outTime: item.checkOut ?? '',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : SizedBox(height: 300.h, child: NoDataFound());
        } else if (state is SupervisorGetEmployeeAttendanceLoading) {
          return const SupervisorEmployeesAttendanceLoadingSkeleton();
        } else {
          return Container();
        }
      },
    );
  }

  bool _matchesSelectedDate(AttendanceItem attendance, DateTime selectedDate) {
    final selectedDay = DateFormat('yyyy-MM-dd').format(selectedDate);

    // Try normalized API date first (usually yyyy-MM-dd).
    if ((attendance.attendanceDate ?? '').startsWith(selectedDay)) {
      return true;
    }

    // Fallback to timestamp fields.
    for (final raw in <String?>[
      attendance.createdDate,
      attendance.checkIn,
      attendance.checkOut,
    ]) {
      if (raw == null || raw.trim().isEmpty) continue;
      final parsed = DateTime.tryParse(raw.trim());
      if (parsed != null &&
          parsed.year == selectedDate.year &&
          parsed.month == selectedDate.month &&
          parsed.day == selectedDate.day) {
        return true;
      }
      if (raw.length >= 10 && raw.substring(0, 10) == selectedDay) {
        return true;
      }
    }

    return false;
  }
}
