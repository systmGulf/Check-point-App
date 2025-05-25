import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_attendance_repo/employee_attendance_repo.dart';

import '../../../../../../core/enums/attendance_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../controller/attendence/attendence_cubit.dart';
import '../organism/employee_check_out_screen_body.dart';

class EmployeeCheckOutScreen extends StatelessWidget {
  const EmployeeCheckOutScreen({super.key, required this.checkType});
  final String checkType;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
      child: Scaffold(
        body: SafeArea(
          child: EmployeeCheckOutScreenBody(
            attendanceType: AttendanceTypeEnum.checkOut,
            checkType: checkType,
          ),
        ),
      ),
    );
  }
}
