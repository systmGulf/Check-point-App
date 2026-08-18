part of 'odoo_dashboard_cubit.dart';

abstract class OdooDashboardState extends Equatable {
  const OdooDashboardState();
  @override
  List<Object?> get props => [];
}

class OdooDashboardInitial extends OdooDashboardState {}

class OdooDashboardLoading extends OdooDashboardState {}

class OdooDashboardSuccess extends OdooDashboardState {
  final Map<String, dynamic> status;
  final OdooMyAttendanceData attendanceData;
  final List<OdooLeaveRequest> leaveRequests;

  const OdooDashboardSuccess({
    required this.status,
    required this.attendanceData,
    required this.leaveRequests,
  });

  @override
  List<Object?> get props => [status, attendanceData, leaveRequests];
}

class OdooDashboardFailure extends OdooDashboardState {
  final String error;
  const OdooDashboardFailure(this.error);

  @override
  List<Object?> get props => [error];
}
