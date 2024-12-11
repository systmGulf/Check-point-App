import '../../features/user_role/employee/employee_home/controller/tasks/tasks_cubit.dart';
import '../../features/user_role/supervisor/supervisor_home/contoller/tasks_cubit/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hr_management_system_package/admin/data/repo/customer_repo/customer_repo.dart';
import 'package:hr_management_system_package/admin/data/repo/department_repo/department_repo.dart';
import 'package:hr_management_system_package/admin/data/repo/employee_repo/admin_manage_employee_repo.dart';
import 'package:hr_management_system_package/employee/data/repo/attendance_repo/employee_attendance_repo.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:hr_management_system_package/register_account/repo/register_account_repo.dart';

import '../../features/intro/presentation/cubit/register_account/register_account_cubit.dart';
import '../../features/user_role/admin/admin_home/controllers/branch_cubit/branch_cubit.dart';
import '../../features/user_role/admin/admin_home/controllers/customer_cubit/customer_cubit.dart';
import '../../features/user_role/admin/admin_home/controllers/department_cubit/department_cubit.dart';
import '../../features/user_role/admin/admin_home/controllers/mange_employee_cubit/employee_cubit.dart';
import '../../features/user_role/employee/employee_home/controller/attendence/attendence_cubit.dart';
import '../../features/user_role/employee/employee_home/controller/change_password/change_password_cubit.dart';
import '../../features/user_role/employee/employee_home/controller/get_employee_history/get_employee_history_cubit.dart';
import '../../features/user_role/employee/employee_home/controller/leave_application/leave_application_cubit.dart';
import '../../features/user_role/supervisor/supervisor_home/contoller/Supervisor_get_employee_attendance/supervisor_get_employee_attendance_cubit.dart';
import '../../features/user_role/supervisor/supervisor_home/contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import '../../features/user_role/supervisor/supervisor_home/contoller/leave_application/leave_application_cubit.dart';
import '../../features/user_role/supervisor/supervisor_home/contoller/plan_cubit/plan_cubit.dart';
import '../contoller/roles_login_cubit/login_cubit.dart';

final getIt = GetIt.instance;
void registerFactory() {
  getIt.registerFactory<LeaveApplicationCubit>(
    () => LeaveApplicationCubit(
      getIt<EmployeeRepo>(),
    ),
  );
  getIt.registerFactory<DepartmentCubit>(
    () => DepartmentCubit(
      getIt<DepartmentRepo>(),
    ),
  );
  getIt.registerFactory<TasksCubit>(
    () => TasksCubit(
      getIt<SupervisorRepo>(),
    ),
  );
  getIt.registerFactory<LeaveApplicationCubitSupervisor>(
    () => LeaveApplicationCubitSupervisor(
      getIt<SupervisorRepo>(),
    ),
  );
  getIt.registerFactory<EmployeeTasksCubit>(
    () => EmployeeTasksCubit(
      getIt<EmployeeRepo>(),
    ),
  );
  getIt.registerFactory<EmployeeCubit>(
    () => EmployeeCubit(
      getIt<AdminManageEmployeeRepo>(),
    ),
  );
  final navigatorKey = GlobalKey<NavigatorState>();
  getIt.registerSingleton<GlobalKey<NavigatorState>>(navigatorKey);
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(
      getIt<LoginRepo>(),
    ),
  );
  getIt.registerFactory<GetEmployeeHistoryCubit>(
    () => GetEmployeeHistoryCubit(
      getIt<EmployeeAttendanceRepo>(),
    ),
  );
  getIt.registerFactory<CustomerCubit>(
    () => CustomerCubit(
      getIt<CustomerRepo>(),
    ),
  );
  getIt.registerFactory<RegisterAccountCubit>(
    () => RegisterAccountCubit(
      getIt<RegisterAccountRepo>(),
    ),
  );
  getIt.registerFactory<EmployeeChangePasswordCubit>(
    () => EmployeeChangePasswordCubit(
      getIt<EmployeeRepo>(),
    ),
  );
  getIt.registerFactory<AttendanceCubit>(
    () => AttendanceCubit(
      getIt<EmployeeAttendanceRepo>(),
    ),
  );
  getIt.registerFactory<BranchCubit>(
    () => BranchCubit(
      getIt<BranchesRepo>(),
    ),
  );
  getIt.registerFactory<SupervisorGetEmployeeAttendanceCubit>(
    () => SupervisorGetEmployeeAttendanceCubit(
      getIt<SupervisorRepo>(),
    ),
  );
  getIt.registerFactory<GetEmployeesDataCubit>(
    () => GetEmployeesDataCubit(
      getIt<SupervisorRepo>(),
    ),
  );
  getIt.registerFactory<PlanCubit>(
    () => PlanCubit(
      getIt<SupervisorRepo>(),
    ),
  );
}
