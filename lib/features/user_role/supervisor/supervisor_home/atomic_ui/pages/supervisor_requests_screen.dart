import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/styles/colors.dart';
import '../../contoller/leave_application/leave_application_cubit.dart';
import 'recent_leave_application.dart';

class SupervisorRequestsScreen extends StatefulWidget {
  const SupervisorRequestsScreen({super.key});

  @override
  State<SupervisorRequestsScreen> createState() =>
      _SupervisorRequestsScreenState();
}

class _SupervisorRequestsScreenState extends State<SupervisorRequestsScreen> {
  int selectedIndex = 0;

  final List<Widget> employeeAttendanceItems = const [
    RecentLeaveApplication(type: 'LeaveRequest'),
    RecentLeaveApplication(type: 'RequestClaim'),
    RecentLeaveApplication(type: 'LeaveSchedule'),
    RecentLeaveApplication(type: 'LeavePlanner'),
    RecentLeaveApplication(type: 'Icident'),
  ];

  @override
  Widget build(BuildContext context) {
    final texts = <String>[
      'Leave Requests'.tr(),
      'Claim Requests'.tr(),
      'Leave Schedule'.tr(),
      'Leave Planner'.tr(),
      'accident'.tr(),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Modern Pill-based Filter Row
        Container(
          height: 60.h,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: texts.length,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemBuilder: (context, index) {
              final isSelected = selectedIndex == index;
              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    final types = ['LeaveRequest', 'RequestClaim', 'LeaveSchedule', 'LeavePlanner', 'Icident'];
                    context.read<LeaveApplicationCubitSupervisor>().getLeaveApplication(
                      type: types[index],
                    );
                  },
                  borderRadius: BorderRadius.circular(20.r),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ColorsManger.primaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected
                            ? ColorsManger.primaryColor
                            : const Color(0xFFE5E7EB),
                        width: 1.2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: ColorsManger.primaryColor.withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        texts[index],
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        // Tab Content
        Expanded(
          child: employeeAttendanceItems[selectedIndex],
        ),
      ],
    );
  }
}
