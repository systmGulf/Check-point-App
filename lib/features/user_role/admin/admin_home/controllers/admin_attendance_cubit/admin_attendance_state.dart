part of 'admin_attendance_cubit.dart';

@immutable
abstract class AdminAttendanceState {
  final DateTime selectedDate;
  const AdminAttendanceState(this.selectedDate);
}

class AdminAttendanceInitial extends AdminAttendanceState {
  const AdminAttendanceInitial(super.selectedDate);
}

class AdminAttendanceLoading extends AdminAttendanceState {
  const AdminAttendanceLoading(super.selectedDate);
}

class AdminAttendanceSuccess extends AdminAttendanceState {
  final UserAttendanceModel employeeAllAttendance;
  const AdminAttendanceSuccess(super.selectedDate, this.employeeAllAttendance);
}

class AdminAttendanceFailure extends AdminAttendanceState {
  final String errorMsg;
  const AdminAttendanceFailure(super.selectedDate, this.errorMsg);
}

class AdminAttendanceExportLoading extends AdminAttendanceState {
  const AdminAttendanceExportLoading(super.selectedDate);
}

class AdminAttendanceExportSuccess extends AdminAttendanceState {
  const AdminAttendanceExportSuccess(super.selectedDate);
}

class AdminAttendanceExportFailure extends AdminAttendanceState {
  final String errorMsg;
  const AdminAttendanceExportFailure(super.selectedDate, this.errorMsg);
}

class AdminAttendanceDeleteLoading extends AdminAttendanceState {
  const AdminAttendanceDeleteLoading(super.selectedDate);
}

class AdminAttendanceDeleteSuccess extends AdminAttendanceState {
  const AdminAttendanceDeleteSuccess(super.selectedDate);
}

class AdminAttendanceDeleteFailure extends AdminAttendanceState {
  final String errorMsg;
  const AdminAttendanceDeleteFailure(super.selectedDate, this.errorMsg);
}
