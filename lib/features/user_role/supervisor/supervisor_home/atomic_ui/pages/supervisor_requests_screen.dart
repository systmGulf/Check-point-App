import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_leave_requests_repo/employee_action_repo.dart';

import '../../../../../../core/dependency%D9%80injection/register%D9%80factory.dart';
import '../../../../../../core/services/odoo_timeoff_service.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../employee/employee_home/atomic_ui/pages/leave_application.dart';
import '../../../../employee/employee_home/controller/leave_application/leave_application_cubit.dart';
import 'recent_leave_application.dart';

// ---------------------------------------------------------------------------
// Wrapper — provides LeaveApplicationCubit and hosts the two-tab layout
// ---------------------------------------------------------------------------
class SupervisorRequestsScreen extends StatelessWidget {
  const SupervisorRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaveApplicationCubit(
        employeeRepo: getIt<EmployeeActionRepo>(),
        odooTimeOffService: getIt<OdooTimeOffService>(),
      ),
      child: const _SupervisorRequestsTabs(),
    );
  }
}

// ---------------------------------------------------------------------------
// Two-tab screen: "Team Requests" | "My Leave"
// ---------------------------------------------------------------------------
class _SupervisorRequestsTabs extends StatefulWidget {
  const _SupervisorRequestsTabs();

  @override
  State<_SupervisorRequestsTabs> createState() =>
      _SupervisorRequestsTabsState();
}

class _SupervisorRequestsTabsState extends State<_SupervisorRequestsTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Top Tab Bar ────────────────────────────────────────────────────
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: ColorsManger.primaryColor,
            unselectedLabelColor: ColorsManger.grey,
            indicatorColor: ColorsManger.primaryColor,
            indicatorWeight: 2.5,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13.5.sp,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13.5.sp,
            ),
            tabs: [
              Tab(text: 'Team Requests'.tr()),
              Tab(text: 'My Leave'.tr()),
            ],
          ),
        ),

        // ── Tab Views ──────────────────────────────────────────────────────
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              // Tab 1 – supervisor manages team leave requests
              _TeamRequestsTab(),

              // Tab 2 – supervisor's own leave (full LeaveApplication screen)
              LeaveApplication(),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 1 – original team-requests content
// ---------------------------------------------------------------------------
class _TeamRequestsTab extends StatefulWidget {
  const _TeamRequestsTab();

  @override
  State<_TeamRequestsTab> createState() => _TeamRequestsTabState();
}

class _TeamRequestsTabState extends State<_TeamRequestsTab> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final texts = <String>[
      'Leave Requests'.tr(),
      'Claim Requests'.tr(),
      'Leave Schedule'.tr(),
      'Leave Planner'.tr(),
      'accident'.tr(),
    ];

    final items = <Widget>[
      const RecentLeaveApplication(type: 'LeaveRequest'),
      const RecentLeaveApplication(type: 'RequestClaim'),
      const RecentLeaveApplication(type: 'LeaveSchedule'),
      const RecentLeaveApplication(type: 'LeavePlanner'),
      const RecentLeaveApplication(type: 'Icident'),
    ];

    return ListView(
      children: [
        // Sub-filter tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            children: items.asMap().entries.map((e) {
              final isSelected = _selectedIndex == e.key;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = e.key),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                      child: Text(
                        texts[e.key],
                        style: isSelected
                            ? AppStylesManger.font14RegularBlack
                                .copyWith(color: ColorsManger.primaryColor)
                            : AppStylesManger.font14RegularBlack
                                .copyWith(color: ColorsManger.grey),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: Divider(
                        color: isSelected
                            ? ColorsManger.primaryColor
                            : ColorsManger.grey,
                        thickness: 1.9,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),

        // Selected content
        items[_selectedIndex],
      ],
    );
  }
}
