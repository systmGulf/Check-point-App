part of 'get_employee_history_cubit.dart';

abstract class GetEmployeeHistoryState extends Equatable {
  const GetEmployeeHistoryState();

  @override
  List<Object> get props => [];
}

class GetEmployeeHistoryInitial extends GetEmployeeHistoryState {}

class GetEmployeeHistoryLoading extends GetEmployeeHistoryState {}

class GetEmployeeHistorySuccess extends GetEmployeeHistoryState {
  final UserAttendanceValue attendanceHistory;
  const GetEmployeeHistorySuccess(this.attendanceHistory);
}

class GetEmployeeHistoryFailure extends GetEmployeeHistoryState {
  final String error;
  const GetEmployeeHistoryFailure(this.error);
}

class GetEmployeeHistoryPaginationLoading extends GetEmployeeHistoryState {}

class GetEmployeeHistoryPaginationFailure extends GetEmployeeHistoryState {
  final String errorMessage;
  const GetEmployeeHistoryPaginationFailure(this.errorMessage);
}
