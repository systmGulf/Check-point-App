part of 'odoo_admin_dashboard_cubit.dart';

abstract class OdooAdminDashboardState extends Equatable {
  const OdooAdminDashboardState();
  @override
  List<Object?> get props => [];
}

class OdooAdminDashboardInitial extends OdooAdminDashboardState {}

class OdooAdminDashboardLoading extends OdooAdminDashboardState {}

class OdooAdminDashboardSuccess extends OdooAdminDashboardState {
  final List<OdooAttendanceLog> attendances;
  final int totalCount;
  final List<OdooPublicHoliday> publicHolidays;
  final List<OdooLeaveType> leaveTypes;

  const OdooAdminDashboardSuccess({
    required this.attendances,
    required this.totalCount,
    required this.publicHolidays,
    required this.leaveTypes,
  });

  @override
  List<Object?> get props => [attendances, totalCount, publicHolidays, leaveTypes];
}

class OdooAdminDashboardFailure extends OdooAdminDashboardState {
  final String error;
  const OdooAdminDashboardFailure(this.error);

  @override
  List<Object?> get props => [error];
}
