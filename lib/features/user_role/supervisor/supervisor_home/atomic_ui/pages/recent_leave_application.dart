import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
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
                                  .getLeaveApplication(type: type);
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
                      return state.getLeaveRequestModel.data!.isEmpty
                          ? Lottie.asset(
                              'assets/animated_images/no_data_found.json')
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                        '${"There are".tr(context: context)} ${state.getLeaveRequestModel.data!.where((e) => e.status == 'Pending').length} ${"Pending Leave Requests".tr(context: context)}',
                                        style: AppStylesManger.font15BoldBlack),
                                    horizontalSpace(10),
                                    Badge.count(
                                      backgroundColor: Colors.blue,
                                      count: state.getLeaveRequestModel.data!
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
                                  itemCount:
                                      state.getLeaveRequestModel.data!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: LeaveApplicationItem(
                                        employeeId: state.getLeaveRequestModel
                                                .data![index].employeeId ??
                                            '',
                                        type: type,
                                        createdBy: state.getLeaveRequestModel
                                                .data![index].createdBy ??
                                            "",
                                        status: state.getLeaveRequestModel
                                                .data![index].status ??
                                            "",
                                        name: state.getLeaveRequestModel
                                                .data![index].employeeName ??
                                            "",
                                        from: state.getLeaveRequestModel
                                                .data![index].startDate ??
                                            "",
                                        to: state.getLeaveRequestModel
                                                .data![index].endDate ??
                                            "",
                                        reason: state.getLeaveRequestModel
                                                .data![index].reason ??
                                            "",
                                        id: state.getLeaveRequestModel
                                                .data![index].id ??
                                            0,
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
