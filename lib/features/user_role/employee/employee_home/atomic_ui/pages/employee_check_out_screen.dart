import '../../../../../../core/enums/attendance_type_enum.dart';
import '../../../../../../core/enums/customer_type.dart';
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
        final attendanceCubit = getIt<AttendanceCubit>();
        attendanceCubit.loadTrackingStatus();
        if (checkType == 'Office') {
          attendanceCubit.getUserBranch();
        } else if (checkType == CustomerType.Customer.name) {
          attendanceCubit.getAttendanceTargets(
            customerType: CustomerType.Customer,
          );
        } else {
          attendanceCubit.getAttendanceTargets(
            customerType: CustomerType.Site,
          );
        }
        return attendanceCubit;
      },
      child: Scaffold(
        body: EmployeeCheckOutScreenBody(
          attendanceType: AttendanceTypeEnum.checkOut,
          checkType: checkType,
        ),
      ),
    );
  }
}
