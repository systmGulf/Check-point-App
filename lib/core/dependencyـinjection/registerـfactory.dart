import 'package:employee_mangement/core/cubits/upload_user_image_cubit/upload_user_image_cubit.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/repo/leave_requests_repo/admin_leave_requests_repo.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/repo/shifts_and_polices_repo/shifts_and_polices_repo.dart';
import 'package:hr_management_system_package/core/notifications/notification_repo.dart';
import 'package:hr_management_system_package/core/repos/shared_repo.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_attendance_repo/employee_attendance_repo.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:hr_management_system_package/register_account/repo/register_account_repo.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/supervisor_attendance_repo/supervisor_attendance_repo.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/supervisor_leave_requests_repo/supervisor_leave_requests_repo.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/supervisor_plans_repo/supervisor_plan_repo.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/supervisor_tasks_repo/supervisor_tasks_repo.dart';

import '../../features/intro/presentation/cubit/register_account/register_account_cubit.dart';
import '../../features/user_role/admin/admin_home/controllers/admin_attendance_cubit/admin_attendance_cubit.dart';
import '../../features/user_role/admin/admin_home/controllers/admin_leave_requests_cubit/admin_leave_requests_cubit.dart';
import '../../features/user_role/admin/admin_home/controllers/branch_cubit/branch_cubit.dart';
import '../../features/user_role/admin/admin_home/controllers/customer_cubit/customer_cubit.dart';
import '../../features/user_role/admin/admin_home/controllers/department_cubit/department_cubit.dart';
import '../../features/user_role/admin/admin_home/controllers/mange_employee_cubit/employee_cubit.dart';
import '../../features/user_role/employee/employee_home/controller/attendence/attendence_cubit.dart';
import '../../features/user_role/employee/employee_home/controller/odoo_dashboard/odoo_dashboard_cubit.dart';
import '../../features/user_role/admin/admin_home/controllers/odoo_admin_dashboard/odoo_admin_dashboard_cubit.dart';
import '../../features/user_role/employee/employee_home/controller/change_password/change_password_cubit.dart';
import '../../features/user_role/employee/employee_home/controller/get_employee_history/get_employee_history_cubit.dart';
import '../../features/user_role/employee/employee_home/controller/leave_application/leave_application_cubit.dart';
import '../../features/user_role/employee/employee_home/controller/tasks/tasks_cubit.dart';
import '../../features/user_role/supervisor/supervisor_home/contoller/Supervisor_get_employee_attendance/supervisor_get_employee_attendance_cubit.dart';
import '../../features/user_role/supervisor/supervisor_home/contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import '../../features/user_role/supervisor/supervisor_home/contoller/leave_application/leave_application_cubit.dart';
import '../../features/user_role/supervisor/supervisor_home/contoller/plan_cubit/plan_cubit.dart';
import '../../features/user_role/supervisor/supervisor_home/contoller/tasks_cubit/tasks_cubit.dart';
import '../contoller/roles_login_cubit/login_cubit.dart';
import '../services/biometric_login_service.dart';
import '../services/odoo_timeoff_service.dart';

final getIt = GetIt.instance;
void registerFactory() {
  final navigatorKey = GlobalKey<NavigatorState>();
  getIt.registerSingleton<GlobalKey<NavigatorState>>(navigatorKey);

  getIt.registerLazySingleton<OdooTimeOffService>(() => OdooTimeOffService());

  // ── Employee cubits ──
  getIt.registerFactory<LeaveApplicationCubit>(
    () => LeaveApplicationCubit(
      employeeRepo: getIt<EmployeeActionRepo>(),
      odooTimeOffService: getIt<OdooTimeOffService>(),
    ),
  );
  getIt.registerFactory<OdooDashboardCubit>(
    () => OdooDashboardCubit(
      odooTimeOffService: getIt<OdooTimeOffService>(),
    ),
  );
  getIt.registerFactory<EmployeeTasksCubit>(
    () => EmployeeTasksCubit(
      employeeRepo: getIt<EmployeeActionRepo>(),
    ),
  );
  getIt.registerFactory<EmployeeChangePasswordCubit>(
    () => EmployeeChangePasswordCubit(
      employeeRepo: getIt<EmployeeActionRepo>(),
    ),
  );
  getIt.registerFactory<AttendanceCubit>(
    () => AttendanceCubit(
      employeeAttendanceRepo: getIt<EmployeeAttendanceRepo>(),
    ),
  );
  getIt.registerFactory<GetEmployeeHistoryCubit>(
    () => GetEmployeeHistoryCubit(
      employeeAttendanceRepo: getIt<EmployeeAttendanceRepo>(),
    ),
  );

  // ── Admin cubits ──
  getIt.registerFactory<DepartmentCubit>(
    () => DepartmentCubit(
      departmentRepo: getIt<DepartmentRepo>(),
    ),
  );
  getIt.registerFactory<EmployeeCubit>(
    () => EmployeeCubit(
      adminManageEmployeeRepo: getIt<AdminManageEmployeeRepo>(),
    ),
  );
  getIt.registerFactory<CustomerCubit>(
    () => CustomerCubit(
      customerRepo: getIt<CustomerRepo>(),
    ),
  );
  getIt.registerFactory<BranchCubit>(
    () => BranchCubit(
      branchesRepo: getIt<BranchesRepo>(),
    ),
  );
  getIt.registerFactory<ShiftsAndPolicesCubit>(
    () => ShiftsAndPolicesCubit(
      shiftsAndPolicesRepo: getIt<ShiftsAndPolicesRepo>(),
    ),
  );
  getIt.registerFactory<AdminAttendanceCubit>(
    () => AdminAttendanceCubit(
      apiService: getIt<ApiService>(),
    ),
  );
  getIt.registerFactory<AdminLeaveRequestsCubit>(
    () => AdminLeaveRequestsCubit(
      adminLeaveRequestsRepo: getIt<AdminLeaveRequestsRepo>(),
    ),
  );
  getIt.registerFactory<OdooAdminDashboardCubit>(
    () => OdooAdminDashboardCubit(
      odooTimeOffService: getIt<OdooTimeOffService>(),
    ),
  );

  // ── Supervisor cubits ──
  getIt.registerFactory<TasksCubit>(
    () => TasksCubit(
      supervisorRepo: getIt<SupervisorTasksRepo>(),
      notificationRepo: getIt<NotificationRepo>(),
    ),
  );
  getIt.registerFactory<LeaveApplicationCubitSupervisor>(
    () => LeaveApplicationCubitSupervisor(
      supervisorRepo: getIt<SupervisorLeaveRequestsRepo>(),
    ),
  );
  getIt.registerFactory<SupervisorGetEmployeeAttendanceCubit>(
    () => SupervisorGetEmployeeAttendanceCubit(
      supervisorRepo: getIt<SupervisorAttendanceRepo>(),
    ),
  );
  getIt.registerFactory<GetEmployeesDataCubit>(
    () => GetEmployeesDataCubit(
      supervisorRepo: getIt<SupervisorAttendanceRepo>(),
    ),
  );
  getIt.registerFactory<PlanCubit>(
    () => PlanCubit(
      supervisorPlanRepo: getIt<SupervisorPlanRepo>(),
      notificationRepo: getIt<NotificationRepo>(),
    ),
  );

  // ── Core/Shared cubits ──
  getIt.registerLazySingleton<BiometricLoginService>(
    () => BiometricLoginService(),
  );
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(
      loginRepo: getIt<LoginRepo>(),
      biometricLoginService: getIt<BiometricLoginService>(),
    ),
  );
  getIt.registerFactory<UploadUserImageCubit>(
    () => UploadUserImageCubit(
      sharedRepo: getIt<SharedRepo>(),
    ),
  );
  getIt.registerFactory<RegisterAccountCubit>(
    () => RegisterAccountCubit(
      registerAccountRepo: getIt<RegisterAccountRepo>(),
    ),
  );
}
