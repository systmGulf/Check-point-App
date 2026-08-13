import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/error_widget.dart';
import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../contoller/leave_application/leave_application_cubit.dart';
import '../atoms/leave_application_item.dart';
import '../molecules/recent_leave_application_loading_skeleton.dart';

class RecentLeaveApplication extends StatefulWidget {
  const RecentLeaveApplication({
    super.key,
    required this.type,
  });
  final String type;

  @override
  State<RecentLeaveApplication> createState() => _RecentLeaveApplicationState();
}

class _RecentLeaveApplicationState extends State<RecentLeaveApplication> {
  bool isLoadingDialogShowing = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LeaveApplicationCubitSupervisor>(context)
        .getLeaveApplication(
      type: widget.type,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<LeaveApplicationCubitSupervisor>(context)
            .getLeaveApplication(
          type: widget.type,
        );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: Column(
                children: [
                  verticalSpace(10),
                BlocConsumer<LeaveApplicationCubitSupervisor,
                    LeaveApplicationState>(
                  listenWhen: (previous, current) =>
                      current is ApproveOrRejectLeaveApplicationLoading ||
                      current is ApproveOrRejectLeaveApplicationSuccess ||
                      current is ApproveOrRejectLeaveApplicationFailure,
                  listener: (context, state) {
                    if (state is ApproveOrRejectLeaveApplicationLoading) {
                      if (!isLoadingDialogShowing) {
                        isLoadingDialogShowing = true;
                        customLoadingIndicator(context);
                      }
                    } else {
                      if (isLoadingDialogShowing) {
                        Navigator.pop(context); // Pop loading dialog
                        isLoadingDialogShowing = false;
                      }
                    }
                  },
                  buildWhen: (previous, current) =>
                      current is GetLeaveApplicationSuccess ||
                      current is GetLeaveApplicationFailure ||
                      current is GetLeaveApplicationLoading,
                  builder: (context, state) {
                    if (state is GetLeaveApplicationFailure) {
                      return CustomErrorWidget(
                          error: state.error,
                          onRetry: () {
                            BlocProvider.of<LeaveApplicationCubitSupervisor>(
                                    context)
                                .getLeaveApplication(
                              type: widget.type,
                            );
                          });
                    }
                    if (state is GetLeaveApplicationSuccess) {
                      return state.getLeaveRequestModel.value!.data!.isEmpty
                          ? Align(
                              alignment: Alignment.topCenter,
                              child: NoDataFound())
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                        '${"There are".tr()} ${state.getLeaveRequestModel.value!.data!.where((e) => e.status == 'Pending').length} ${"Pending Leave Requests".tr()}',
                                        style: AppStylesManger.font15BoldBlack),
                                    horizontalSpace(10),
                                    Badge.count(
                                      backgroundColor: Colors.red,
                                      count: state
                                          .getLeaveRequestModel.value!.data!
                                          .where((e) => e.status == 'Pending')
                                          .length,
                                      child: Icon(Icons.notifications_on,
                                          color: Colors.grey.shade400),
                                    )
                                  ],
                                ),
                                verticalSpace(10),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: state
                                      .getLeaveRequestModel.value!.data!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: ElasticInUp(
                                        child: LeaveApplicationItem(
                                          userToken: state
                                                  .getLeaveRequestModel
                                                  .value!
                                                  .data![index]
                                                  .employee!
                                                  .deviceTokens!
                                                  .isNotEmpty
                                              ? state
                                                  .getLeaveRequestModel
                                                  .value!
                                                  .data![index]
                                                  .employee!
                                                  .deviceTokens!
                                                  .first
                                              : '',
                                          employeeId: state
                                                  .getLeaveRequestModel
                                                  .value!
                                                  .data![index]
                                                  .employee
                                                  ?.id ??
                                              '',
                                          type: widget.type,
                                          createdBy: state
                                                  .getLeaveRequestModel
                                                  .value!
                                                  .data![index]
                                                  .createdBy ??
                                              "",
                                          status: state.getLeaveRequestModel
                                                  .value!.data![index].status ??
                                              "",
                                          name: state
                                                  .getLeaveRequestModel
                                                  .value!
                                                  .data![index]
                                                  .employee
                                                  ?.userName ??
                                              state
                                                  .getLeaveRequestModel
                                                  .value!
                                                  .data![index]
                                                  .employee
                                                  ?.name ??
                                              "",
                                          from: state
                                                  .getLeaveRequestModel
                                                  .value!
                                                  .data![index]
                                                  .startDate ??
                                              "",
                                          to: state.getLeaveRequestModel.value!
                                                  .data![index].endDate ??
                                              "",
                                          reason: state.getLeaveRequestModel
                                                  .value!.data![index].reason ??
                                              "",
                                          id: state.getLeaveRequestModel.value!
                                                  .data![index].id ??
                                              0,
                                          role: state.getLeaveRequestModel.value!
                                                  .data![index].employee?.role ??
                                              "",
                                          department: state.getLeaveRequestModel.value!
                                                  .data![index].employee?.departmentName ??
                                              "",
                                          position: state.getLeaveRequestModel.value!
                                                  .data![index].employee?.position ??
                                              "",
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                    }
                    return const RecentLeaveApplicationLoadingSkeleton();
                  },
                ),
              ],
            ),
          )
        ],
      ),
     ),
    );
  }
}
