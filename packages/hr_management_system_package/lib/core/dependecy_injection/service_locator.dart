import 'package:get_it/get_it.dart';
import 'package:hr_management_system_package/core/notifications/notification_repo.dart';
import 'package:hr_management_system_package/core/notifications/notifications_repo_impl.dart';
import 'package:hr_management_system_package/core/repos/shared_repo.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/supervisor_attendance_repo/supervisor_attendance_repo_impl.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/supervisor_leave_requests_repo/supervisor_leave_requests_repo_impl.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/supervisor_plans_repo/supervisor_plan_repo_impl.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../admin_infrastructure/data/repo/shifts_and_polices_repo/shifts_and_polices_repo_impl.dart';
import '../../admin_infrastructure/data/repo/shifts_and_polices_repo/shifts_and_polices_repo.dart';
import '../../employee_infrastructure/data/repo/employee_attendance_repo/employee_attendance_repo.dart';
import '../../employee_infrastructure/data/repo/employee_attendance_repo/employee_attendance_repo_impl.dart';
import '../../hr_manamgement_system_package.dart';
import '../../register_account/repo/register_account_repo.dart';
import '../../register_account/repo/register_account_repo_impl.dart';
import '../../supervisor_infrastructure/data/repo/supervisor_attendance_repo/supervisor_attendance_repo.dart';
import '../../supervisor_infrastructure/data/repo/supervisor_leave_requests_repo/supervisor_leave_requests_repo.dart';
import '../../supervisor_infrastructure/data/repo/supervisor_plans_repo/supervisor_plan_repo.dart';
import '../../supervisor_infrastructure/data/repo/supervisor_tasks_repo/supervisor_tasks_repo.dart';
import '../../supervisor_infrastructure/data/repo/supervisor_tasks_repo/supervisor_tasks_repo_impl.dart';
import '../common_methods/network_checker.dart';
import '../common_methods/check_accessiable_area_service.dart';
import '../repos/shared_repo_impl.dart';
import '../networking/odoo_attendance_service.dart';

final getIt = GetIt.instance;

void setUpServiceLocator() {
  // Register ApiService
  getIt.registerLazySingleton<NetworkChecker>(
    () => NetworkChecker(),
  );
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(
      dio: DioFactory.getDio(),
    ),
  );
  getIt.registerLazySingleton<OdooAttendanceService>(
    () => OdooAttendanceService(),
  );
  getIt.registerLazySingleton<SupervisorTasksRepo>(
    () => SupervisorTasksRepoImpl(
      apiService: getIt<ApiService>(),
    ),
  );

  getIt.registerLazySingleton<SupervisorPlanRepo>(
    () => SupervisorPlanRepoImpl(
      apiService: getIt<ApiService>(),
    ),
  );
  getIt.registerLazySingleton<SharedRepo>(
    () => SharedRepoImpl(
      apiService: getIt<ApiService>(),
    ),
  );
  getIt.registerLazySingleton<SupervisorLeaveRequestsRepo>(
    () => SupervisorLeaveRequestsRepoImpl(
      apiservice: getIt<ApiService>(),
    ),
  );
  getIt.registerLazySingleton<SupervisorAttendanceRepo>(
    () => SupervisorAttendanceRepoImpl(
      apiService: getIt<ApiService>(),
      odooAttendanceService: getIt<OdooAttendanceService>(),
    ),
  );

  // Register other repositories and services
  getIt.registerLazySingleton<RegisterAccountRepo>(
    () => RegisterAccountRepoImpl(
      apiService: getIt<ApiService>(),
    ),
  );

  getIt.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.instance,
  );

  getIt.registerLazySingleton<NotificationRepo>(
    () => NotificationsRepoImpl(
      apiService: getIt<ApiService>(),
    ),
  );

  getIt.registerSingleton<LoginRepo>(
    LoginRepoImpl(
      apiservice: getIt<ApiService>(),
    ),
  );

  getIt.registerSingleton<ShiftsAndPolicesRepo>(
    ShiftsAndPolicesRepoImpl(
      apiService: getIt<ApiService>(),
    ),
  );

  getIt.registerSingleton<CheckAccessibleAreaService>(
    CheckAccessibleAreaService(),
  );

  getIt.registerSingleton<EmployeeAttendanceRepo>(
    EmployeeAttendanceRepoImpl(
      getIt<CheckAccessibleAreaService>(),
      apiService: getIt<ApiService>(),
      odooAttendanceService: getIt<OdooAttendanceService>(),
    ),
  );

  getIt.registerSingleton<EmployeeActionRepo>(
    EmployeeActionRepoImpl(
      apiService: getIt<ApiService>(),
    ),
  );

  getIt.registerSingleton<BranchesRepo>(
    AdminRepoImpl(
      apiService: getIt<ApiService>(),
    ),
  );

  getIt.registerSingleton<CustomerRepo>(
    CustomerRepoImpl(
      apiService: getIt<ApiService>(),
    ),
  );

  getIt.registerSingleton<DepartmentRepo>(
    DepartmentRepoImpl(
      apiService: getIt<ApiService>(),
    ),
  );

  getIt.registerSingleton<AdminManageEmployeeRepo>(
    AdminManageEmployeeRepoImpl(
      apiService: getIt<ApiService>(),
    ),
  );

  getIt.registerSingleton<AdminLeaveRequestsRepo>(
    AdminLeaveRequestsRepoImpl(
      apiservice: getIt<ApiService>(),
    ),
  );
}
