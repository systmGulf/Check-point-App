import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../organism/employee_attendace.dart';

class SupervisorEmployeesAttendanceLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const SupervisorEmployeesAttendanceLoadingSkeleton({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: EmployeeAttendance(
              feedbacks: [],
              isEarly: false,
              isLate: false,
              employeeId: '',
              totalHours: double.parse('0.12').toStringAsFixed(2),
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
  }
}
