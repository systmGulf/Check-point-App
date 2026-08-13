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

class ApproveOrRejectLeaveApplicationLoading extends LeaveApplicationState {
  final int id;
  const ApproveOrRejectLeaveApplicationLoading({required this.id});

  @override
  List<Object> get props => [id];
}

class ApproveOrRejectLeaveApplicationSuccess extends LeaveApplicationState {
  final int id;
  final String status;
  const ApproveOrRejectLeaveApplicationSuccess({required this.id, required this.status});

  @override
  List<Object> get props => [id, status];
}

class ApproveOrRejectLeaveApplicationFailure extends LeaveApplicationState {
  final String error;
  final int id;

  const ApproveOrRejectLeaveApplicationFailure({required this.error, required this.id});

  @override
  List<Object> get props => [error, id];
}
