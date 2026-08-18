import '../../../../../../core/enums/attendance_type_enum.dart';
import '../../../../../../core/enums/customer_type.dart';
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
        child: EmployeeCheckInScreenBody(
          attendanceType: AttendanceTypeEnum.checkIn,
          checkType: checkType,
        ),
      ),
    );
  }
}
