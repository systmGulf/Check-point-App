import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../contoller/Supervisor_get_employee_attendance/supervisor_get_employee_attendance_cubit.dart';
import '../../contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import '../../contoller/share_attendace_cubit/shareattendance_cubit.dart';
import '../atoms/employee_list.dart';
import '../molecules/attendace.dart';

class EmployeeAttendance extends StatefulWidget {
  const EmployeeAttendance({super.key});

  @override
  State<EmployeeAttendance> createState() => _EmployeeAttendanceState();
}

class _EmployeeAttendanceState extends State<EmployeeAttendance> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> texts = [
      'Attendance'.tr(),
      'Employees'.tr()
    ];
    return SafeArea(
      child: RefreshIndicator(
        color: ColorsManger.primaryColor,
        onRefresh: () async {
          context
              .read<SupervisorGetEmployeeAttendanceCubit>()
              .supervisorGetEmployeesAttendanceByDepartmentId();

          context.read<GetEmployeesDataCubit>().getEmployeesByDepartmentId();
        },
        child: ListView(
          children: [
            verticalSpace(20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: employeeAttendanceItems
                    .asMap()
                    .entries
                    .map((e) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = e.key;
                            });
                          },
                          child: Column(
                            children: [
                              FadeTransition(
                                opacity: AlwaysStoppedAnimation(
                                    selectedIndex == e.key ? 1.0 : 0.5),
                                child: Text(texts[e.key],
                                    style: selectedIndex == e.key
                                        ? AppStylesManger.font14RegularBlack
                                            .copyWith(
                                                color:
                                                    ColorsManger.primaryColor)
                                        : AppStylesManger.font14RegularBlack
                                            .copyWith(
                                                color: ColorsManger.grey)),
                              ),
                              verticalSpace(8),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Divider(
                                  color: selectedIndex == e.key
                                      ? ColorsManger.primaryColor
                                      : ColorsManger.grey,
                                  thickness: 1.9,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            employeeAttendanceItems[selectedIndex],
          ],
        ),
      ),
    );
  }

  List<Widget> employeeAttendanceItems = [
    BlocProvider(
      create: (context) => ShareattendanceCubit(),
      child: const EmployeesAttendance(),
    ),
    const EmployeeList(),
  ];
}
