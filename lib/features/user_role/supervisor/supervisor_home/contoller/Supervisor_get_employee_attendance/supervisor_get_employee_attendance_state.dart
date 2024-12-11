part of 'supervisor_get_employee_attendance_cubit.dart';

abstract class SupervisorGetEmployeeAttendanceState {
  final DateTime selectedDate;

  const SupervisorGetEmployeeAttendanceState(this.selectedDate);
}

abstract class SupervisorGetEmployeesData extends Equatable {}

class SupervisorGetEmployeeAttendanceInitial
    extends SupervisorGetEmployeeAttendanceState {
  const SupervisorGetEmployeeAttendanceInitial(super.selectedDate);
}

class SupervisorGetEmployeeAttendanceLoading
    extends SupervisorGetEmployeeAttendanceState {
  const SupervisorGetEmployeeAttendanceLoading(super.selectedDate);
}

class SupervisorGetEmployeeAttendanceSuccess
    extends SupervisorGetEmployeeAttendanceState {
  final SupervisorGetAllEmployeesAttendanceValue employeeAllAttendance;

  const SupervisorGetEmployeeAttendanceSuccess(
      super.selectedDate, this.employeeAllAttendance);
}

class SupervisorGetEmployeeAttendanceFailure
    extends SupervisorGetEmployeeAttendanceState {
  final String errorMsg;

  const SupervisorGetEmployeeAttendanceFailure(
      super.selectedDate, this.errorMsg);
}

class SupervisorGetLateComersLoading
    extends SupervisorGetEmployeeAttendanceState {
  const SupervisorGetLateComersLoading(super.selectedDate);
}

class SupervisorGetLateComersSuccess
    extends SupervisorGetEmployeeAttendanceState {
  final SupervisorGetAllEmployeesAttendanceValue employeeAllAttendance;

  const SupervisorGetLateComersSuccess(
      super.selectedDate, this.employeeAllAttendance);
}

class SupervisorGetLateComersFailure
    extends SupervisorGetEmployeeAttendanceState {
  final String errorMsg;

  const SupervisorGetLateComersFailure(super.selectedDate, this.errorMsg);
}

class SupervisorGetEarlyLeaversLoading
    extends SupervisorGetEmployeeAttendanceState {
  const SupervisorGetEarlyLeaversLoading(super.selectedDate);
}

class SupervisorGetEarlyLeaversSuccess
    extends SupervisorGetEmployeeAttendanceState {
  final SupervisorGetAllEmployeesAttendanceValue employeeAllAttendance;

  const SupervisorGetEarlyLeaversSuccess(
      super.selectedDate, this.employeeAllAttendance);
}

class SupervisorGetEarlyLeaversFailure
    extends SupervisorGetEmployeeAttendanceState {
  final String errorMsg;

  const SupervisorGetEarlyLeaversFailure(super.selectedDate, this.errorMsg);
}
