import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/no_data_found_animation_widget.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../../../../../core/services/odoo_timeoff_service.dart';
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
  String? selectedStateFilter; // null for All, 'confirm', 'validate', 'refuse'

  @override
  void initState() {
    _fetchRequests();
    super.initState();
  }

  void _fetchRequests() {
    BlocProvider.of<LeaveApplicationCubit>(context)
        .fetchMyOdooLeaveRequests(stateFilter: selectedStateFilter);
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat(
        tr('date_format', context: context), context.locale.toString());
    return Scaffold(
      appBar: buildCustomAppBar(context, 'My Leave Requests'.tr()),
      body: Column(
        children: [
          // Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterTab(null, 'All'.tr()),
                  const SizedBox(width: 8),
                  _buildFilterTab('confirm', 'Pending'.tr()),
                  const SizedBox(width: 8),
                  _buildFilterTab('validate', 'Approved'.tr()),
                  const SizedBox(width: 8),
                  _buildFilterTab('refuse', 'Rejected'.tr()),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: RefreshIndicator(
                color: ColorsManger.primaryColor,
                onRefresh: () async {
                  _fetchRequests();
                },
                child: ListView(
                  children: [
                    BlocBuilder<LeaveApplicationCubit, LeaveApplicationState>(
                      builder: (context, state) {
                        if (state is GetLeaveApplicationFailure) {
                          return state.error == 'Please check your internet connection'
                              ? NoInternetConnectionWidget(onPressed: () {
                                  _fetchRequests();
                                })
                              : Column(
                                  children: [
                                    const Icon(Icons.error, color: Colors.red),
                                    verticalSpace(20),
                                    Text(state.error)
                                  ],
                                );
                        }
                        if (state is OdooGetLeaveRequestsSuccess) {
                          final requests = state.requests;
                          if (requests.isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
                                const Center(
                                  child: NoDataFound(),
                                ),
                              ],
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: requests.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final req = requests[index];
                              // Map Odoo status to display labels
                              String displayStatus = 'Pending';
                              if (req.state == 'validate') {
                                displayStatus = 'Approved';
                              } else if (req.state == 'refuse') {
                                displayStatus = 'Rejected';
                              }

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: EmployeeLeaveRequestItem(
                                  type: req.leaveTypeName,
                                  id: req.id,
                                  from: dateFormat.format(DateTime.parse(req.dateFrom)).toString(),
                                  to: dateFormat.format(DateTime.parse(req.dateTo)).toString(),
                                  reason: req.reason,
                                  status: displayStatus.tr(),
                                ),
                              );
                            },
                          );
                        }
                        return Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.sizeOf(context).height * 0.3,
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String? stateValue, String label) {
    final isSelected = selectedStateFilter == stateValue;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: isSelected,
      selectedColor: ColorsManger.primaryColor,
      backgroundColor: Colors.grey[200],
      onSelected: (selected) {
        if (selected) {
          setState(() {
            selectedStateFilter = stateValue;
          });
          _fetchRequests();
        }
      },
    );
  }
}
