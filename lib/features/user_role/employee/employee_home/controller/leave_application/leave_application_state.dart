part of 'leave_application_cubit.dart';

abstract class LeaveApplicationState extends Equatable {
  const LeaveApplicationState();

  @override
  List<Object> get props => [];
}

class LeaveApplicationInitial extends LeaveApplicationState {}

class GetLeaveTypesLoading extends LeaveApplicationState {}
class GetLeaveTypesSuccess extends LeaveApplicationState {
  final List<OdooLeaveType> leaveTypes;
  const GetLeaveTypesSuccess(this.leaveTypes);
  @override
  List<Object> get props => [leaveTypes];
}
class GetLeaveTypesFailure extends LeaveApplicationState {
  final String error;
  const GetLeaveTypesFailure(this.error);
  @override
  List<Object> get props => [error];
}

class GetPublicHolidaysLoading extends LeaveApplicationState {}
class GetPublicHolidaysSuccess extends LeaveApplicationState {
  final List<OdooPublicHoliday> publicHolidays;
  const GetPublicHolidaysSuccess(this.publicHolidays);
  @override
  List<Object> get props => [publicHolidays];
}
class GetPublicHolidaysFailure extends LeaveApplicationState {
  final String error;
  const GetPublicHolidaysFailure(this.error);
  @override
  List<Object> get props => [error];
}

class OdooGetLeaveRequestsSuccess extends LeaveApplicationState {
  final List<OdooLeaveRequest> requests;
  const OdooGetLeaveRequestsSuccess(this.requests);
  @override
  List<Object> get props => [requests];
}

class AddLeaveApplicationLoading extends LeaveApplicationState {}

class AddLeaveApplicationSuccess extends LeaveApplicationState {}

class AddLeaveApplicationFailure extends LeaveApplicationState {
  final String error;
  const AddLeaveApplicationFailure(this.error);
}

class GetLeaveApplicationLoading extends LeaveApplicationState {}

class GetLeaveApplicationSuccess extends LeaveApplicationState {
  final EmployeeLeaveRequestsValue employeeLeaveRequests;

  const GetLeaveApplicationSuccess({required this.employeeLeaveRequests});
}

class GetLeaveApplicationFailure extends LeaveApplicationState {
  final String error;
  const GetLeaveApplicationFailure(this.error);
}

class DeleteLeaveRequestLoading extends LeaveApplicationState {}

class DeleteLeaveRequestSuccess extends LeaveApplicationState {}

class DeleteLeaveRequestFailure extends LeaveApplicationState {
  final String error;
  const DeleteLeaveRequestFailure(this.error);
}

class ChangeAppLanguageLoading extends LeaveApplicationState {}

class ChangeAppLanguageSuccess extends LeaveApplicationState {}

class GetEmployeesByDepartmentIdFailure extends LeaveApplicationState {
  final String error;
  const GetEmployeesByDepartmentIdFailure(this.error);
}

class GetEmployeesByDepartmentIdSuccess extends LeaveApplicationState {
  final GetAllEmployeesValue employees;
  const GetEmployeesByDepartmentIdSuccess({required this.employees});
}

class GetEmployeesByDepartmentIdLoading extends LeaveApplicationState {}
