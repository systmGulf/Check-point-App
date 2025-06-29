part of 'leave_application_cubit.dart';

abstract class LeaveApplicationState extends Equatable {
  const LeaveApplicationState();

  @override
  List<Object> get props => [];
}

class LeaveApplicationInitial extends LeaveApplicationState {}

class GetLeaveApplicationLoading extends LeaveApplicationState {}

class GetLeaveApplicationSuccess extends LeaveApplicationState {
  final GetLeaveRequestModel getLeaveRequestModel;

  const GetLeaveApplicationSuccess({required this.getLeaveRequestModel});
}

class GetLeaveApplicationFailure extends LeaveApplicationState {
  final String error;

  const GetLeaveApplicationFailure({required this.error});
}

class ApproveOrRejectLeaveApplicationLoading extends LeaveApplicationState {}

class ApproveOrRejectLeaveApplicationSuccess extends LeaveApplicationState {}

class ApproveOrRejectLeaveApplicationFailure extends LeaveApplicationState {
  final String error;

  const ApproveOrRejectLeaveApplicationFailure({required this.error});
}
