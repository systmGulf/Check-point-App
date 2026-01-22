import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../organism/employee_attendace.dart';

class SupervisorLateComersLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const SupervisorLateComersLoadingSkeleton({
    super.key,
    this.itemCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(top: 10),
            child: EmployeeAttendance(
              isEarly: false,
              isLate: false,
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
      ),
    );
  }
}
