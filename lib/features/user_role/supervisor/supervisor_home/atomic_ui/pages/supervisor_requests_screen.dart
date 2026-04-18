import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/leave_application/leave_application_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../atoms/leave_requests_type.dart';
import 'recent_leave_application.dart';

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
    // final texts = <String>[
    //   'Leave Requests'.tr(context: context),
    //   'Claim Requests'.tr(context: context),
    //   'Leave Schedule'.tr(context: context),
    //   'Leave Planner'.tr(context: context),
    //   'accident'.tr(context: context),
    // ];
    return BlocBuilder<LeaveApplicationCubitSupervisor, LeaveApplicationState>(
        buildWhen: (previous, current) {
      return current is GetLeaveTypeSuccessState;
    }, builder: (context, state) {
      return switch (state) {
        GetLeaveTypeLoadingState() => Skeletonizer(
            child: LeaveRequestsType(
              text: "",
              style: AppStylesManger.font14RegularBlack,
              color: ColorsManger.grey,
            ),
          ),
        GetLeaveTypeFailureState() => Center(
            child: NoDataFound(),
          ),
        GetLeaveTypeSuccessState(getLeaveTypeModel: final getLeaveTypeModel) =>
          Builder(builder: (context) {
            final leaveTypes = getLeaveTypeModel.value ?? [];

            if (leaveTypes.isEmpty) {
              return const Center(child: NoDataFound());
            }

            if (selectedIndex >= leaveTypes.length) {
              selectedIndex = 0;
            }

            final selectedType = leaveTypes[selectedIndex].type ?? '';

            return ListView(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: leaveTypes.asMap().entries.map((e) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = e.key;
                        });
                      },
                      child: LeaveRequestsType(
                          text:
                              state.getLeaveTypeModel.value![e.key].type ?? '',
                          style: selectedIndex == e.key
                              ? AppStylesManger.font14RegularBlack.copyWith(
                                  color: ColorsManger.primaryColor,
                                )
                              : AppStylesManger.font14RegularBlack
                                  .copyWith(color: ColorsManger.grey),
                          color: selectedIndex == e.key
                              ? ColorsManger.primaryColor
                              : ColorsManger.grey),
                    );
                  }).toList(),
                ),
              ),
              RecentLeaveApplication(
                key: ValueKey(selectedType),
                type: selectedType,
              ),
            ],
          );
          }),
        _ => SizedBox.shrink(),
      };
    });
  }
}
