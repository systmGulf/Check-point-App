import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/enums/request_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_filter_container.dart';
import '../../../../../../core/widgets/custom_filter_floating_action_button.dart';
import 'recent_leave_application.dart';

class SupervisorRequestsScreen extends StatefulWidget {
  const SupervisorRequestsScreen({super.key});

  @override
  State<SupervisorRequestsScreen> createState() =>
      _SupervisorRequestsScreenState();
}

int selectedIndex = 0;
String? selectedStatus;

class _SupervisorRequestsScreenState extends State<SupervisorRequestsScreen> {
  @override
  Widget build(BuildContext context) {
     List<Widget> employeeAttendanceItems = [
    RecentLeaveApplication(
      type: 'LeaveRequest',
      selectedStatus: selectedStatus,
    ),
    RecentLeaveApplication(
      type: 'RequestClaim',
      selectedStatus: selectedStatus,
    ),
    RecentLeaveApplication(
      type: 'LeaveSchedule',
      selectedStatus: selectedStatus,
    ),
    RecentLeaveApplication(
      type: 'LeavePlanner',
      selectedStatus: selectedStatus,
    ),
    RecentLeaveApplication(
      type: 'Icident',
      selectedStatus: selectedStatus,
    ),
  ];
    final texts = <String>[
      'Leave Requests'.tr(context: context),
      'Claim Requests'.tr(context: context),
      'Leave Schedule'.tr(context: context),
      'Leave Planner'.tr(context: context),
      'accident'.tr(context: context),
    ];
    return Scaffold(
      floatingActionButton: CustomFilterFloatingActionButton(
        onPressed: () async {
          final filterData = await showModalBottomSheet<Map<String, dynamic>>(
            backgroundColor: Colors.white,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            context: context,
            builder: (ctx) {
              return CustomFilterContainer(
                statusOne: "Cancelled".tr(
                  context: context,
                ),
                statusTwo: "Approved".tr(
                  context: context,
                ),
                statusThree: "Pending".tr(
                  context: context,
                ),
              );
            },
          );

          if (filterData != null) {
            setState(() {
              if (filterData['statusOne'] == true) {
                selectedStatus = RequestStatus.Cancelled.name;
              } else if (filterData['statusTwo'] == true) {
                selectedStatus = RequestStatus.Approved.name;
                ;
              } else if (filterData['statusThree'] == true) {
                selectedStatus = RequestStatus.Pending.name;
                ;
              } else {
                selectedStatus = null;
              }
            });
          }
        },
      ),
      body: ListView(
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
      ),
    );
  }

 
}
