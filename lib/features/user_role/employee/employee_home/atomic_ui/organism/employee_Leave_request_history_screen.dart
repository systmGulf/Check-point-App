import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/no_data_found_animation_widget.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../controller/leave_application/leave_application_cubit.dart';
import 'employee_leave_request_item.dart';

class EmployeeLeaveRequestsHistoryScreen extends StatefulWidget {
  const EmployeeLeaveRequestsHistoryScreen({
    super.key,
    required this.type,
  });
  final String type;

  @override
  State<EmployeeLeaveRequestsHistoryScreen> createState() =>
      _EmployeeLeaveRequestsHistoryScreenState();
}

class _EmployeeLeaveRequestsHistoryScreenState
    extends State<EmployeeLeaveRequestsHistoryScreen> {
  @override
  void initState() {
    BlocProvider.of<LeaveApplicationCubit>(context)
        .GetLeaveRequestByType(type: widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat(
        tr('date_format', context: context), context.locale.toString());
    return Scaffold(
        appBar: buildCustomAppBar(
            context, 'My Leave Requests'.tr(context: context)),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: RefreshIndicator(
            color: ColorsManger.primaryColor,
            onRefresh: () async {
              BlocProvider.of<LeaveApplicationCubit>(context)
                  .GetLeaveRequestByType(type: widget.type);
            },
            child: ListView(children: [
              BlocBuilder<LeaveApplicationCubit, LeaveApplicationState>(
                builder: (context, state) {
                  if (state is GetLeaveApplicationFailure) {
                    return state.error ==
                            'Please check your internet connection'
                        ? NoInternetConnectionWidget(onPressed: () {
                            context
                                .read<LeaveApplicationCubit>()
                                .GetLeaveRequestByType(type: widget.type);
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
                    return state.employeeLeaveRequests.data!.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Column(
                                  children: const [
                                    NoDataFound(),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.employeeLeaveRequests.data!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: EmployeeLeaveRequestItem(
                                  type: widget.type,
                                  id: state.employeeLeaveRequests.data![index]
                                          .id ??
                                      0,
                                  from: dateFormat
                                      .format(DateTime.parse(state
                                          .employeeLeaveRequests
                                          .data![index]
                                          .startDate
                                          .toString()))
                                      .toString(),
                                  to: dateFormat
                                      .format(DateTime.parse(state
                                          .employeeLeaveRequests
                                          .data![index]
                                          .endDate
                                          .toString()))
                                      .toString(),
                                  reason: state.employeeLeaveRequests
                                          .data![index].reason ??
                                      "",
                                  status: state.employeeLeaveRequests
                                          .data![index].status
                                          ?.tr(context: context) ??
                                      "",
                                ),
                              );
                            });
                  }
                  return Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.sizeOf(context).height * 0.45,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ColorsManger.primaryColor,
                        strokeWidth: 2,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  );
                },
              )
            ]),
          ),
        ));
  }
}
