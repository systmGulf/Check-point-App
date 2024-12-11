import 'package:flutter/material.dart';

import 'calender_widget.dart';
import 'share_exal_file_bloc_listener.dart';
import 'supervisor_get_all_employees_attendance_bloc_builder.dart';

class Attendance extends StatelessWidget {
  const Attendance({super.key});
  static const employee = 10;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: CalenderWidget(
              onTap: () {},
            )),
        Divider(
          thickness: 1,
          color: Colors.grey[300],
        ),
        const SupervisorGetAllEmployeesAttendanceBlocBuilder(),
        const ShareExalFileBlocListener(),
      ],
    );
  }
}
