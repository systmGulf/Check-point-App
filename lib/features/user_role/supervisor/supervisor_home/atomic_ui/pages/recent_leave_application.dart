import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/get_leave_Request_model/get_leave_request_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../contoller/leave_application/leave_application_cubit.dart';
import '../atoms/leave_application_item.dart';

class RecentLeaveApplication extends StatefulWidget {
  const RecentLeaveApplication({
    super.key,
    required this.type,
    this.selectedStatus,
  });
  final String type;
  final String? selectedStatus;

  @override
  State<RecentLeaveApplication> createState() => _RecentLeaveApplicationState();
}

class _RecentLeaveApplicationState extends State<RecentLeaveApplication> {
  List<Data> _filterRequests(List<Data> requests) {
      if (widget.selectedStatus == null) return requests;
    return requests.where((task) {
      final matchesStatus = widget.selectedStatus == null ||
          task.status!.toLowerCase() == widget.selectedStatus!.toLowerCase();

      return matchesStatus;
    }).toList();
  }
  @override
  void initState() {
    BlocProvider.of<LeaveApplicationCubitSupervisor>(context)
        .getLeaveApplication(
      type: widget.type,
    );
    super.initState();
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
                      return state.error ==
                              'Please check your internet connection'
                          ? NoInternetConnectionWidget(onPressed: () {
                              context
                                  .read<LeaveApplicationCubitSupervisor>()
                                  .getLeaveApplication(type: widget.type);
                            })
                          : Column(
                              children: [
                                const Icon(Icons.error, color: Colors.red),
                                verticalSpace(20),
                                Text(state.error)
                              ],
                            );
                    }
                    if (state is GetLeaveApplicationSuccess) {
                      final request = _filterRequests(
                          state.getLeaveRequestModel.value!.data!);
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
                                      backgroundColor: Colors.blue,
                                      count: state
                                          .getLeaveRequestModel.value!.data!
                                          .where((e) => e.status == 'Pending')
                                          .length,
                                      child: Icon(Icons.notifications_on,
                                          color: ColorsManger.primaryColor),
                                    )
                                  ],
                                ),
                                verticalSpace(10),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: request.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: LeaveApplicationItem(
                                        userImage:
                                            request[index].employee?.imageUrl ??
                                                '',
                                        userToken: request[index]
                                                .employee!
                                                .deviceTokens!
                                                .isNotEmpty
                                            ? request[index]
                                                .employee!
                                                .deviceTokens!
                                                .first
                                            : '',
                                        employeeId:
                                            request[index].employee?.id ?? '',
                                        type: widget.type,
                                        createdBy:
                                            request[index].createdBy ?? "",
                                        status: request[index].status ?? "",
                                        name:
                                            request[index].employee?.name ?? "",
                                        from: request[index].startDate ?? "",
                                        to: request[index].endDate ?? "",
                                        reason: request[index].reason ?? "",
                                        id: request[index].id ?? 0,
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
                            userImage: '',
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
