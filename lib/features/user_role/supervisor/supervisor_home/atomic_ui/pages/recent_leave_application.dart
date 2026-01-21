import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/error_widget.dart';
import '../../contoller/leave_application/leave_application_cubit.dart';
import '../atoms/leave_application_item.dart';

class RecentLeaveApplication extends StatelessWidget {
  const RecentLeaveApplication({
    super.key,
    required this.type,
  });
  final String type;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LeaveApplicationCubitSupervisor>(context)
        .getLeaveApplication(
      type: type,
    );
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<LeaveApplicationCubitSupervisor>(context)
            .getLeaveApplication(
          type: type,
        );
      },
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
                BlocBuilder<LeaveApplicationCubitSupervisor,
                    LeaveApplicationState>(
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
                              type: type,
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
                                        '${"There are".tr(context: context)} ${state.getLeaveRequestModel.value!.data!.where((e) => e.status == 'Pending').length} ${"Pending Leave Requests".tr(context: context)}',
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
                                          type: type,
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
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                    }
                    return Skeletonizer(
                        child: ListView.builder(
                      itemBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: LeaveApplicationItem(
                            userToken: 'Data Load',
                            employeeId: 'Data load',
                            type: 'Data Load',
                            createdBy: 'Data Load',
                            status: 'Data Load',
                            name: 'Data Load',
                            from: '2024-11-11',
                            to: '2024-11-30',
                            reason: 'Data Load',
                            id: 0,
                          ),
                        );
                      },
                      itemCount: 10,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                    ));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
