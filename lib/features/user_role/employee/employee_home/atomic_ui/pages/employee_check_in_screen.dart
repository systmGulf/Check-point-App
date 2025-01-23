import 'package:hr_management_system_package/employee/data/repo/employee_attendance_repo/employee_attendance_repo.dart';

import '../../../../../../core/enums/attendance_type_enum.dart';
import '../../controller/attendence/attendence_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../organism/employee_check_in_screen_body.dart';

class EmployeeCheckInScreen extends StatelessWidget {
  const EmployeeCheckInScreen({super.key, required this.checkType});
  final String checkType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: BlocProvider(
        create: (context) {
          final attendanceCubit =
              AttendanceCubit(getIt<EmployeeAttendanceRepo>());
          if (checkType == 'Office') {
            attendanceCubit.getUserBranch();
          } else {
            attendanceCubit.getCustomerArea();
          }
          return attendanceCubit;
        },
        child: SafeArea(
          child: EmployeeCheckInScreenBody(
            attendanceType: AttendanceTypeEnum.checkIn,
            checkType: checkType,
          ),
        ),
      ),
    );
  }
}
