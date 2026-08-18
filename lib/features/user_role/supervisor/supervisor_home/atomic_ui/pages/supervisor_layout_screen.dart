import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/app_settings_screen.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/leave_application/leave_application_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:employee_mangement/core/services/odoo_timeoff_service.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_leave_requests_repo/employee_action_repo.dart';

import '../../../../../../core/dependency%D9%80injection/register%D9%80factory.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../employee/employee_home/atomic_ui/molecules/employee_more_option_drawer.dart';
import '../../../../employee/employee_home/atomic_ui/organism/employee_custom_drawer.dart';
import '../../../../employee/employee_home/controller/tasks/tasks_cubit.dart';
import '../../contoller/Supervisor_get_employee_attendance/supervisor_get_employee_attendance_cubit.dart';
import '../../contoller/leave_application/leave_application_cubit.dart';
import '../../contoller/tasks_cubit/tasks_cubit.dart';
import 'attandace_screen.dart';
import 'supervisor_home_screen.dart';
import 'supervisor_requests_screen.dart';
import 'supervisor_tasks_screen.dart';

class SupervisorLayoutScreen extends StatefulWidget {
  const SupervisorLayoutScreen({super.key});
  static GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

  @override
  State<SupervisorLayoutScreen> createState() => _SupervisorLayoutScreenState();
}

class _SupervisorLayoutScreenState extends State<SupervisorLayoutScreen> {
  int selectedIndex = 0;
  PageController controller = PageController();

  static GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    List<String> texts = [
      'Home'.tr(),
      'Attendance'.tr(),
      'Tasks'.tr(),
      'Requests'.tr(),
      'Settings'.tr(),
    ];
    return Scaffold(
      key: scaffoldkey,
      endDrawer: const Drawer(
        child: EmployeeCustomDrawer(),
      ),
      drawer: Drawer(
        child: BlocProvider(
          create: (context) => LeaveApplicationCubit(
            employeeRepo: getIt<EmployeeActionRepo>(),
            odooTimeOffService: getIt<OdooTimeOffService>(),
          ),
          child: const EmployeeMoreOptionDrawer(),
        ),
      ),
      appBar: selectedIndex == 0 || selectedIndex == 4
          ? null // Home and Settings screens have their own headers
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    scaffoldkey.currentState?.openEndDrawer();
                  },
                  icon: CircleAvatar(
                    backgroundColor: ColorsManger.primaryColor,
                    radius: 20,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ],
              centerTitle: true,
              leadingWidth: 80.w,
              title: Text(
                texts[selectedIndex],
                style: AppStylesManger.font18BoldBlack,
              ),
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
                controller.animateToPage(
                  selectedIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutQuad,
                );
              },
              backgroundColor: Colors.white,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: ColorsManger.primaryColor,
              unselectedItemColor: Colors.grey,
              selectedFontSize: 12.sp,
              unselectedFontSize: 11.sp,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_rounded),
                  activeIcon: Icon(Icons.home_rounded, color: ColorsManger.primaryColor),
                  label: 'Home'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.calendar_month_rounded),
                  activeIcon: Icon(Icons.calendar_month_rounded, color: ColorsManger.primaryColor),
                  label: 'Attendance'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.assignment_rounded),
                  activeIcon: Icon(Icons.assignment_rounded, color: ColorsManger.primaryColor),
                  label: 'Tasks'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.pending_actions_rounded),
                  activeIcon: Icon(Icons.pending_actions_rounded, color: ColorsManger.primaryColor),
                  label: 'Requests'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings_rounded),
                  activeIcon: Icon(Icons.settings_rounded, color: ColorsManger.primaryColor),
                  label: 'Settings'.tr(),
                ),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: screens,
      ),
    );
  }

  List<Widget> screens = [
    const SupervisorHomeScreenBody(),
    BlocProvider(
      create: (context) => getIt<SupervisorGetEmployeeAttendanceCubit>()
        ..supervisorGetEmployeesAttendanceByDepartmentId(),
      child: const EmployeeAttendance(),
    ),
    BlocProvider(
      create: (context) => getIt<TasksCubit>()..getTasks(),
      child: SupervisorTasksScreen(),
    ),
    BlocProvider(
      create: (context) => getIt<LeaveApplicationCubitSupervisor>(),
      child: const SupervisorRequestsScreen(),
    ),
    const AppSettingsScreen(),
  ];
}
