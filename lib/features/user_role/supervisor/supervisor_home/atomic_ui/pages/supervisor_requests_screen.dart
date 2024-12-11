import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import 'recent_leave_application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupervisorRequestsScreen extends StatefulWidget {
  const SupervisorRequestsScreen({super.key});

  @override
  State<SupervisorRequestsScreen> createState() =>
      _SupervisorRequestsScreenState();
}

int selectedIndex = 0;

class _SupervisorRequestsScreenState extends State<SupervisorRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    final texts = <String>[
      'Leave Requests'.tr(context: context),
      'Claim Requests'.tr(context: context),
      'Leave Schedule'.tr(context: context),
      'Leave Planner'.tr(context: context),
      'accident'.tr(context: context),
    ];
    return ListView(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: employeeAttendanceItems
                .asMap()
                .entries
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = e.key;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          texts[e.key],
                          style: selectedIndex == e.key
                              ? AppStylesManger.font14RegularBlack.copyWith(
                                  color: ColorsManger.primaryColor,
                                )
                              : AppStylesManger.font14RegularBlack
                                  .copyWith(color: ColorsManger.grey),
                        ),
                        SizedBox(height: 8.h),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Divider(
                            color: selectedIndex == e.key
                                ? ColorsManger.primaryColor
                                : ColorsManger.grey,
                            thickness: 1.9,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        employeeAttendanceItems[selectedIndex],
      ],
    );
  }

  List<Widget> employeeAttendanceItems = [
    const RecentLeaveApplication(
      type: 'LeaveRequest',
    ),
    const RecentLeaveApplication(
      type: 'RequestClaim',
    ),
    const RecentLeaveApplication(
      type: 'LeaveSchedule',
    ),
    const RecentLeaveApplication(
      type: 'LeavePlanner',
    ),
    const RecentLeaveApplication(
      type: 'Icident',
    ),
  ];
}
