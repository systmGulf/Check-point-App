import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/error_widget.dart';
import '../../contoller/leave_application/leave_application_cubit.dart';
import '../atoms/leave_application_item.dart';
import '../pages/recent_leave_application_loading_skeleton.dart';

class RecentLeaveApplication extends StatelessWidget {
  const RecentLeaveApplication({
    super.key,
    required this.type,
  });
  final String type;

  String _extractUserToken(dynamic requestor) {
    if (requestor is Map<String, dynamic>) {
      final tokens = requestor['deviceTokens'];
      if (tokens is List && tokens.isNotEmpty) {
        return tokens.first?.toString() ?? '';
      }
    }
    return '';
  }

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
                      final leaveRequests = state.getLeaveRequestModel.value ?? [];
                      return leaveRequests.isEmpty
                      return state.getLeaveRequestModel.value!.isEmpty
                          ? Align(
                              alignment: Alignment.topCenter,
                              child: NoDataFound())
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                        '${"There are".tr(context: context)} ${leaveRequests.where((e) => e.status == 0).length} ${"Pending Leave Requests".tr(context: context)}',
                                        '${"There are".tr(context: context)} ${state.getLeaveRequestModel.value!.where((e) => e.status == 'Pending').length} ${"Pending Leave Requests".tr(context: context)}',
                                        style: AppStylesManger.font15BoldBlack),
                                    horizontalSpace(10),
                                    Badge.count(
                                      backgroundColor: Colors.red,
                                      count: leaveRequests
                                          .where((e) => e.status == 0)
                                      count: state.getLeaveRequestModel.value!
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
                                  itemCount: leaveRequests.length,
                                  itemCount:
                                      state.getLeaveRequestModel.value!.length,
                                  itemBuilder: (context, index) {
                                    final item = leaveRequests[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: ElasticInUp(
                                        child: LeaveApplicationItem(
                                          userToken:
                                              _extractUserToken(item.requestor),
                                          employeeId: item.requestorId ?? '',
                                          type: type,
                                          createdBy: item.requestorId ?? "",
                                          status: item.status ?? 0,
                                          name: item.requestorName ?? "",
                                          from: item.leavePeriod?.startDate ?? "",
                                          to: item.leavePeriod?.endDate ?? "",
                                          reason: item.reason ?? "",
                                          id: item.id ?? '',
                                          reason: state.getLeaveRequestModel
                                                  .value?[index].reason ??
                                              '',
                                          to: state
                                              .getLeaveRequestModel
                                              .value?[index]
                                              .leavePeriod
                                              ?.endDate,
                                          from: state
                                              .getLeaveRequestModel
                                              .value?[index]
                                              .leavePeriod
                                              ?.startDate,
                                          name: state.getLeaveRequestModel
                                              .value?[index].requestorName,
                                          id: int.tryParse(state
                                                  .getLeaveRequestModel
                                                  .value![index]
                                                  .id!) ??
                                              0,
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
    );
  }
}
