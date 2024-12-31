import 'package:employee_mangement/features/user_role/admin/admin_home/atomic_ui/pages/police_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/admin/admin_data.dart';
import 'package:hr_management_system_package/employee/data/repo/attendance_repo/employee_attendance_repo.dart';

import '../../features/intro/presentation/cubit/register_account/register_account_cubit.dart';
import '../../features/intro/presentation/views/screen/on_boarding_screen.dart';
import '../../features/intro/presentation/views/screen/user_role_screen.dart';
import '../../features/splash/presentation/view/screen/splash_screen.dart';
import '../../features/user_role/admin/admin_auth/ui/view/views/admin_login_screen.dart';
import '../../features/user_role/admin/admin_home/atomic_ui/pages/admin_home_screen.dart';
import '../../features/user_role/admin/admin_home/atomic_ui/pages/admin_notification_screen.dart';
import '../../features/user_role/admin/admin_home/atomic_ui/pages/all_users_screen.dart';
import '../../features/user_role/admin/admin_home/atomic_ui/pages/clients_screen.dart';
import '../../features/user_role/admin/admin_home/atomic_ui/pages/company_branches_details_screen.dart';
import '../../features/user_role/admin/admin_home/atomic_ui/pages/company_branshes_screen.dart';
import '../../features/user_role/admin/admin_home/atomic_ui/pages/departments_screen.dart.dart';
import '../../features/user_role/admin/admin_home/atomic_ui/pages/edit_user_screen.dart';
import '../../features/user_role/admin/admin_home/atomic_ui/pages/holidays_screen.dart';
import '../../features/user_role/admin/admin_home/atomic_ui/pages/notifiy_users_screen.dart';
import '../../features/user_role/admin/admin_home/atomic_ui/pages/shifts_screen.dart';
import '../../features/user_role/admin/admin_home/atomic_ui/pages/sites_screen.dart';
import '../../features/user_role/admin/admin_home/atomic_ui/pages/team_in_department_screen.dart';
import '../../features/user_role/admin/admin_home/atomic_ui/pages/terms_and_conditions_screen.dart';
import '../../features/user_role/admin/admin_home/controllers/branch_cubit/branch_cubit.dart';
import '../../features/user_role/admin/admin_home/controllers/customer_cubit/customer_cubit.dart';
import '../../features/user_role/admin/admin_home/controllers/department_cubit/department_cubit.dart';
import '../../features/user_role/admin/admin_home/controllers/mange_employee_cubit/employee_cubit.dart';
import '../../features/user_role/admin/admin_home/controllers/notification_cubit/notification_cubit.dart';
import '../../features/user_role/admin/admin_home/controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import '../../features/user_role/employee/employee_auth/ui/views/screen/employee_login_screen.dart';
import '../../features/user_role/employee/employee_home/atomic_ui/organism/employee_Leave_request_history_screen.dart';
import '../../features/user_role/employee/employee_home/atomic_ui/organism/employee_change_password_screen.dart';
import '../../features/user_role/employee/employee_home/atomic_ui/pages/employee_add_new_customer_screen.dart';
import '../../features/user_role/employee/employee_home/atomic_ui/pages/employee_attendance_history_screen.dart';
import '../../features/user_role/employee/employee_home/atomic_ui/pages/employee_check_in_screen.dart';
import '../../features/user_role/employee/employee_home/atomic_ui/pages/employee_check_out_screen.dart';
import '../../features/user_role/employee/employee_home/atomic_ui/pages/employee_home_screen.dart';
import '../../features/user_role/employee/employee_home/atomic_ui/pages/incident_myself.dart';
import '../../features/user_role/employee/employee_home/atomic_ui/pages/incident_team.dart';
import '../../features/user_role/employee/employee_home/atomic_ui/pages/leave_application.dart';
import '../../features/user_role/employee/employee_home/atomic_ui/pages/leave_planner.dart';
import '../../features/user_role/employee/employee_home/atomic_ui/pages/leave_schedule.dart';
import '../../features/user_role/employee/employee_home/atomic_ui/pages/my_plans.screen.dart';
import '../../features/user_role/employee/employee_home/atomic_ui/pages/my_tasks_screen.dart';
import '../../features/user_role/employee/employee_home/atomic_ui/pages/request_claim_application_screen.dart';
import '../../features/user_role/employee/employee_home/atomic_ui/pages/workflow_submission.dart';
import '../../features/user_role/employee/employee_home/controller/attendence/attendence_cubit.dart';
import '../../features/user_role/employee/employee_home/controller/change_password/change_password_cubit.dart';
import '../../features/user_role/employee/employee_home/controller/get_employee_history/get_employee_history_cubit.dart';
import '../../features/user_role/employee/employee_home/controller/leave_application/leave_application_cubit.dart';
import '../../features/user_role/employee/employee_home/controller/tasks/tasks_cubit.dart';
import '../../features/user_role/supervisor/supervisor_auth/ui/views/widgets/screen/supervisor_login_screen.dart';
import '../../features/user_role/supervisor/supervisor_home/atomic_ui/pages/Supervisor_add_tasks_screen.dart';
import '../../features/user_role/supervisor/supervisor_home/atomic_ui/pages/employee_preview.dart';
import '../../features/user_role/supervisor/supervisor_home/atomic_ui/pages/sub_plans_screen.dart';
import '../../features/user_role/supervisor/supervisor_home/atomic_ui/pages/supervisor_attend_some_employee_screen.dart';
import '../../features/user_role/supervisor/supervisor_home/atomic_ui/pages/supervisor_home_screen.dart';
import '../../features/user_role/supervisor/supervisor_home/atomic_ui/pages/supervisor_notification_screen.dart';
import '../../features/user_role/supervisor/supervisor_home/contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import '../../features/user_role/supervisor/supervisor_home/contoller/tasks_cubit/tasks_cubit.dart';
import '../contoller/roles_login_cubit/login_cubit.dart';
import '../dependency%D9%80injection/register%D9%80factory.dart';
import '../enums/customer_type.dart';
import '../widgets/no_route_screen.dart';
import 'base_route.dart';
import 'routes.dart';

abstract class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return BaseRoute(
          page: const SplashScreen(),
        );
      case Routes.myTasksScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<EmployeeTasksCubit>()..getMyTasks(),
            child: const MyTasksScreen(),
          ),
        );
      case Routes.supervisorAddTasksScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<TasksCubit>(),
            child: const SupervisorAddTasksScreen(),
          ),
        );
      case Routes.leaveApplicationScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<LeaveApplicationCubit>(),
            child: const LeaveApplication(),
          ),
        );
      case Routes.onboardingscreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<RegisterAccountCubit>(),
            child: const OnBoardingScreen(),
          ),
        );
      case Routes.myLeaveRequestsScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<LeaveApplicationCubit>(),
            child: EmployeeLeaveRequestsHistoryScreen(
              type: settings.arguments! as String,
            ),
          ),
        );
      case Routes.userRoleScreen:
        return BaseRoute(
          page: const UserRoleScreen(),
        );
      case Routes.departmentPermission:
        final arr = settings.arguments! as List;
        return BaseRoute(
          page: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<DepartmentCubit>(),
              ),
              BlocProvider(
                create: (context) => getIt<EmployeeCubit>(),
              ),
            ],
            child: DepartmentUsersAndPermission(
              text: arr[0] as String,
              departmentId: arr[1] as int,
            ),
          ),
        );
      case Routes.employeeLoginScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const EmployeeLoginScreen(),
          ),
        );

      case Routes.adminHomeScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<EmployeeCubit>()..getAllEmployees(),
            child: const AdminHomeScreen(),
          ),
        );
      case Routes.employeeHomeScreen:
        return BaseRoute(
          page: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    getIt<GetEmployeeHistoryCubit>()..getEmployeeHistory(),
              ),
              BlocProvider(
                create: (context) => getIt<LoginCubit>()..getEmployeeById(),
              ),
              BlocProvider(
                create: (context) => getIt<EmployeeTasksCubit>()..getMyTasks(),
              ),
            ],
            child: const EmployeeHomeScreen(),
          ),
        );
      case Routes.employeeCheckInScreen:
        return BaseRoute(
          page: EmployeeCheckInScreen(
            checkType: settings.arguments! as String,
          ),
        );
      case Routes.supervisorLoginScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const SupervisorLoginScreen(),
          ),
        );
      case Routes.requestClaimApplicationScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<LeaveApplicationCubit>()
              ..GetLeaveRequestByType(type: 'RequestClaim'),
            child: const RequestClaimApplicationScreen(),
          ),
        );
      case Routes.supervisorHomeScreen:
        return BaseRoute(
          page: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<LoginCubit>()..getEmployeeById(),
              ),
              BlocProvider(
                create: (context) => getIt<GetEmployeesDataCubit>()
                  ..getEmployeesByDepartmentId(),
              ),
            ],
            child: const SupervisorHomeScreen(),
          ),
        );
      case Routes.employeeCheckOutScreen:
        return BaseRoute(
          page: EmployeeCheckOutScreen(
            checkType: settings.arguments! as String,
          ),
        );

      case Routes.employeePreview:
        final arr = settings.arguments! as List;
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<GetEmployeesDataCubit>(),
            child: EmployeePreview(
              employeeId: arr[0] as String,
              month: arr[1] as int,
              year: arr[2] as int,
            ),
          ),
        );
      case Routes.leavePlanner:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<LeaveApplicationCubit>(),
            child: const LeavePlanner(),
          ),
        );
      case Routes.leaveSchedule:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<LeaveApplicationCubit>(),
            child: const LeaveSchedule(),
          ),
        );
      case Routes.clientsScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) {
              return getIt<CustomerCubit>()
                ..getCustomersByType(customerType: CustomerType.Customer);
            },
            child: const ClientsScreen(),
          ),
        );

      case Routes.workflowSubmission:
        return BaseRoute(
          page: const WorkflowSubmission(),
        );
      case Routes.supervisorNotificationsScreen:
        return BaseRoute(
          page: const SupervisorNotificationsScreen(),
        );
      case Routes.adminNotificationScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) =>
                getIt<EmployeeCubit>()..getAddAccountRequests(),
            child: const AdminNotificationScreen(),
          ),
        );

      case Routes.incidentMyself:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<LeaveApplicationCubit>(),
            child: const IncidentMyself(),
          ),
        );
      case Routes.supervisorAttendSomeEmployeeScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<GetEmployeesDataCubit>(),
            child: SupervisorAttendSomeEmployeeScreen(
              getEmployeesValue: settings.arguments! as EmployeeData,
            ),
          ),
        );
      case Routes.companyBranchDetails:
        final arr = settings.arguments! as List;
        return BaseRoute(
          page: CompanyBranchDetailsScreen(
            name: arr[0] as String,
            location: arr[1] as String,
            description: arr[2] as String,
            points: arr[3] as List<GetBranchesCoordinates>,
          ),
        );
      case Routes.employeeChangePasswordScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<EmployeeChangePasswordCubit>(),
            child: const EmployeeChangePasswordScreen(),
          ),
        );

      case Routes.incidentTeam:
        return BaseRoute(
          page: BlocProvider(
            create: (context) =>
                getIt<LeaveApplicationCubit>()..getEmployeesByDepartmentId(),
            child: const IncidentTeam(),
          ),
        );
      case Routes.adminLoginScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const AdminLoginScreen(),
          ),
        );
      case Routes.termsAndConditionsScreen:
        return BaseRoute(
          page: const TermsAndConditionsScreen(),
        );
      case Routes.allUsersScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<EmployeeCubit>()..getAllEmployees(),
            child: AllUsersScreen(
              addAccountRequestValue:
                  settings.arguments as AddAccountRequestData?,
            ),
          ),
        );
      case Routes.editUser:
        return BaseRoute(
          page: EditUser(
            branchId: settings.arguments! as int,
            branch: settings.arguments! as String,
            departmentId: settings.arguments! as int,
            role: settings.arguments! as String,
            mobileId: settings.arguments! as String,
            id: settings.arguments! as String,
            name: settings.arguments! as String,
            userName: settings.arguments! as String,
            position: settings.arguments! as String,
            department: settings.arguments! as String,
          ),
        );
      case Routes.supervisorPermission:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<DepartmentCubit>()..getAllDepartments(),
            child: const DepartmentScreen(),
          ),
        );
      case Routes.holidaysScreen:
        return BaseRoute(
          page: const HolidaysScreen(),
        );
      case Routes.myPlansScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<AttendanceCubit>()..getCustomerArea(),
            child: const MyPlansScreen(),
          ),
        );
      case Routes.employeeAddNewCustomerScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<CustomerCubit>(),
            child: const EmployeeAddNewCustomerScreen(),
          ),
        );
      case Routes.policeScreen:
        return BaseRoute(
          page: const PoliceScreen(),
        );
      case Routes.shiftsScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) =>
                getIt<ShiftsAndPolicesCubit>()..getShifts(isLoading: true),
            child: const ShiftsScreen(),
          ),
        );
      case Routes.sitesScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) {
              return getIt<CustomerCubit>()
                ..getCustomersByType(customerType: CustomerType.Site);
            },
            child: const SitesScreen(),
          ),
        );
      case Routes.subPlansScreen:
        return BaseRoute(page: const SubPlansScreen());
      case Routes.notifyUsersScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => NotificationCubit(),
            child: const NotifyUsersScreen(),
          ),
        );
      case Routes.employeeAttendanceHistoryScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) =>
                GetEmployeeHistoryCubit(getIt<EmployeeAttendanceRepo>())
                  ..getEmployeeHistory(),
            child: const EmployeeAttendanceHistoryScreen(),
          ),
        );
      case Routes.companyBranchesScreen:
        return BaseRoute(
          page: BlocProvider(
            create: (context) => getIt<BranchCubit>()
              ..getBranches(
                isLoading: true,
              ),
            child: const CompanyBranchesScreen(),
          ),
        );

      default:
        return BaseRoute(
          page: const NoRouteScreen(),
        );
    }
  }
}
