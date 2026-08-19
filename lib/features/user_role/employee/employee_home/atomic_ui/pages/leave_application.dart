import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../../../../../core/widgets/no_data_found_animation_widget.dart';
import '../../../../../../core/services/odoo_timeoff_service.dart';
import '../../controller/leave_application/leave_application_cubit.dart';
import '../atoms/date_button_leave_request.dart';
import '../organism/create_leave_application_bloc_listiner.dart';
import '../organism/employee_leave_request_item.dart';

class LeaveApplication extends StatefulWidget {
  final int initialTabIndex;
  const LeaveApplication({super.key, this.initialTabIndex = 0});

  @override
  State<LeaveApplication> createState() => _LeaveApplicationState();
}

class _LeaveApplicationState extends State<LeaveApplication> {
  late TextEditingController reasonController;
  late TextEditingController remarkController;
  GlobalKey<FormState> formKey = GlobalKey();
  String? selectedStateFilter; // null for All, 'confirm', 'validate', 'refuse'

  @override
  void initState() {
    reasonController = BlocProvider.of<LeaveApplicationCubit>(context).reasonController;
    remarkController = BlocProvider.of<LeaveApplicationCubit>(context).remarkController;
    
    // Fetch all required data from Odoo on load
    final cubit = BlocProvider.of<LeaveApplicationCubit>(context);
    cubit.fetchLeaveTypes();
    cubit.fetchPublicHolidays();
    cubit.fetchMyOdooLeaveRequests(stateFilter: selectedStateFilter);
    
    super.initState();
  }

  @override
  void dispose() {
    reasonController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat(
        tr('date_format', context: context), context.locale.toString());

    return BlocBuilder<LeaveApplicationCubit, LeaveApplicationState>(
      buildWhen: (previous, current) =>
          current is GetLeaveTypesLoading ||
          current is GetLeaveTypesSuccess ||
          current is GetLeaveTypesFailure,
      builder: (context, state) {
        final cubit = BlocProvider.of<LeaveApplicationCubit>(context);
        
        if (state is GetLeaveTypesFailure) {
          return Scaffold(
            backgroundColor: ColorsManger.scaffoldBackgroundColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: ColorsManger.scaffoldBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF24252C)),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 64.sp),
                    verticalSpace(16),
                    Text(
                      'Failed to load leave types'.tr(),
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    verticalSpace(8),
                    Text(
                      state.error.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                    verticalSpace(24),
                    ElevatedButton.icon(
                      onPressed: () {
                        cubit.fetchLeaveTypes();
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text('Retry'.tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManger.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is GetLeaveTypesLoading || cubit.leaveTypes.isEmpty) {
          return Scaffold(
            backgroundColor: ColorsManger.scaffoldBackgroundColor,
            body: Center(
              child: CircularProgressIndicator(color: ColorsManger.primaryColor),
            ),
          );
        }

        return DefaultTabController(
          length: 3,
          initialIndex: widget.initialTabIndex,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: ColorsManger.scaffoldBackgroundColor,
              surfaceTintColor: Colors.transparent,
              title: Text(
                'Request Leave'.tr(),
                style: const TextStyle(
                  color: Color(0xFF24252C),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF24252C)),
                onPressed: () => Navigator.maybePop(context),
              ),
              bottom: TabBar(
                labelColor: ColorsManger.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: ColorsManger.primaryColor,
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                tabs: [
                  Tab(text: 'Request Leave'.tr()),
                  Tab(text: 'Public Holidays'.tr()),
                  Tab(text: 'My Leaves'.tr()),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // TAB 1: Request Leave Form
                _buildRequestLeaveTab(),

                // TAB 2: Public Holidays List
                _buildPublicHolidaysTab(dateFormat),

                // TAB 3: My Leaves & Balance
                _buildMyLeavesTab(dateFormat),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestLeaveTab() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: ListView(
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text('Leave Type'.tr(), style: AppStylesManger.font12RegularGrey),
            ),
            verticalSpace(10),
            BlocBuilder<LeaveApplicationCubit, LeaveApplicationState>(
              buildWhen: (previous, current) =>
                  current is GetLeaveTypesSuccess ||
                  current is GetLeaveTypesFailure ||
                  current is GetLeaveTypesLoading,
              builder: (context, state) {
                final cubit = BlocProvider.of<LeaveApplicationCubit>(context);
                final types = cubit.leaveTypes;

                // Use id as the dropdown value to avoid reference-equality assertion
                final selectedId = cubit.selectedLeaveType?.id;
                // Guard: ensure selectedId exists in the current list
                final validId = types.any((t) => t.id == selectedId)
                    ? selectedId
                    : (types.isNotEmpty ? types.first.id : null);

                return DropdownButtonFormField<int>(
                  value: validId,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                  items: types.map((type) {
                    return DropdownMenuItem<int>(
                      value: type.id,
                      child: Text(type.name),
                    );
                  }).toList(),
                  onChanged: (id) {
                    if (id == null) return;
                    setState(() {
                      cubit.selectedLeaveType =
                          types.firstWhere((t) => t.id == id);
                    });
                  },
                );
              },
            ),
            verticalSpace(15),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text('Duration'.tr(), style: AppStylesManger.font12RegularGrey),
            ),
            verticalSpace(10),
            Row(
              children: [
                Expanded(
                  child: DateButtonLeaveRequest(
                    placeholder: 'From'.tr(),
                    dateField: LeaveRequestDateField.from,
                  ),
                ),
                horizontalSpace(10),
                Expanded(
                  child: DateButtonLeaveRequest(
                    placeholder: 'To'.tr(),
                    dateField: LeaveRequestDateField.to,
                  ),
                ),
              ],
            ),
            verticalSpace(15),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text('Reason'.tr(), style: AppStylesManger.font12RegularGrey),
            ),
            verticalSpace(10),
            CustomAppTextFormField(
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Reason Required'.tr();
                }
                return null;
              },
              controller: reasonController,
              hint: 'Reason * (200 Characters Max)'.tr(),
            ),
            verticalSpace(20),
            CustomAppButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  BlocProvider.of<LeaveApplicationCubit>(context).sendOdooLeaveRequest();
                }
              },
              textButton: 'Submit'.tr(),
              buttonColor: ColorsManger.primaryColor,
            ),
            const CreateLeaveApplicationBlocListener(
              requestType: "Leave Request",
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPublicHolidaysTab(DateFormat dateFormat) {
    return BlocBuilder<LeaveApplicationCubit, LeaveApplicationState>(
      buildWhen: (previous, current) =>
          current is GetPublicHolidaysSuccess ||
          current is GetPublicHolidaysFailure ||
          current is GetPublicHolidaysLoading,
      builder: (context, state) {
        final cubit = BlocProvider.of<LeaveApplicationCubit>(context);
        if (state is GetPublicHolidaysLoading) {
          return Center(child: CircularProgressIndicator(color: ColorsManger.primaryColor));
        }
        if (state is GetPublicHolidaysFailure) {
          return Center(child: Text(state.error));
        }
        if (cubit.publicHolidays.isEmpty) {
          return const Center(child: NoDataFound());
        }
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          itemCount: cubit.publicHolidays.length,
          itemBuilder: (context, index) {
            final holiday = cubit.publicHolidays[index];
            final fromDate = dateFormat.format(DateTime.parse(holiday.dateFrom));
            final toDate = dateFormat.format(DateTime.parse(holiday.dateTo));
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: ColorsManger.primaryColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: ColorsManger.primaryColor.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: ColorsManger.primaryColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.beach_access_rounded,
                      color: ColorsManger.primaryColor,
                      size: 24.sp,
                    ),
                  ),
                  horizontalSpace(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          holiday.name,
                          style: TextStyle(
                            color: const Color(0xFF24252C),
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        verticalSpace(4),
                        Text(
                          '$fromDate - $toDate',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMyLeavesTab(DateFormat dateFormat) {
    return BlocBuilder<LeaveApplicationCubit, LeaveApplicationState>(
      builder: (context, state) {
        final cubit = BlocProvider.of<LeaveApplicationCubit>(context);

        // Calculate leave balance details
        double approvedDays = 0.0;
        double pendingDays = 0.0;
        for (var req in cubit.odooRequests) {
          if (req.state == 'validate') {
            approvedDays += req.numberOfDays;
          } else if (req.state == 'confirm') {
            pendingDays += req.numberOfDays;
          }
        }
        double remainingBalance = 21.0 - approvedDays;
        if (remainingBalance < 0) remainingBalance = 0;

        return RefreshIndicator(
          color: ColorsManger.primaryColor,
          onRefresh: () async {
            cubit.fetchMyOdooLeaveRequests(stateFilter: selectedStateFilter);
          },
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            children: [
              // Balance Card Row – hidden per request
              // Row(
              //   children: [
              //     Expanded(
              //       child: _buildBalanceCard('Remaining'.tr(), '${remainingBalance.toStringAsFixed(1)} ${'Days'.tr()}', Colors.green),
              //     ),
              //     horizontalSpace(8),
              //     Expanded(
              //       child: _buildBalanceCard('Approved'.tr(), '${approvedDays.toStringAsFixed(1)} ${'Days'.tr()}', ColorsManger.primaryColor),
              //     ),
              //     horizontalSpace(8),
              //     Expanded(
              //       child: _buildBalanceCard('Pending'.tr(), '${pendingDays.toStringAsFixed(1)} ${'Days'.tr()}', Colors.orange),
              //     ),
              //   ],
              // ),
              // verticalSpace(15),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(null, 'All'.tr()),
                    const SizedBox(width: 8),
                    _buildFilterChip('confirm', 'Pending'.tr()),
                    const SizedBox(width: 8),
                    _buildFilterChip('validate', 'Approved'.tr()),
                    const SizedBox(width: 8),
                    _buildFilterChip('refuse', 'Rejected'.tr()),
                  ],
                ),
              ),
              verticalSpace(15),

              // List of my leaves
              if (state is GetLeaveApplicationLoading)
                Center(child: CircularProgressIndicator(color: ColorsManger.primaryColor))
              else if (cubit.odooRequests.isEmpty)
                const Center(child: NoDataFound())
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cubit.odooRequests.length,
                  itemBuilder: (context, index) {
                    final req = cubit.odooRequests[index];
                    String displayStatus = 'Pending';
                    if (req.state == 'validate') {
                      displayStatus = 'Approved';
                    } else if (req.state == 'refuse') {
                      displayStatus = 'Rejected';
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
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
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalanceCard(String title, String value, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.bold)),
            verticalSpace(6),
            Text(value, style: TextStyle(fontSize: 14.sp, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String? stateValue, String label) {
    final isSelected = selectedStateFilter == stateValue;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
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
          BlocProvider.of<LeaveApplicationCubit>(context)
              .fetchMyOdooLeaveRequests(stateFilter: selectedStateFilter);
        }
      },
    );
  }
}
