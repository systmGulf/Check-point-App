part of 'admin_leave_requests_cubit.dart';

abstract class AdminLeaveRequestsState extends Equatable {
  const AdminLeaveRequestsState();

  @override
  List<Object?> get props => [];
}

class AdminLeaveRequestsInitial extends AdminLeaveRequestsState {}

class GetAllLeaveRequestsLoading extends AdminLeaveRequestsState {}

class GetAllLeaveRequestsSuccess extends AdminLeaveRequestsState {
  final GetLeaveRequestModel getLeaveRequestModel;

  const GetAllLeaveRequestsSuccess({required this.getLeaveRequestModel});

  @override
  List<Object?> get props => [getLeaveRequestModel];
}

class GetAllLeaveRequestsFailure extends AdminLeaveRequestsState {
  final String error;

  const GetAllLeaveRequestsFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class ApproveOrRejectAdminLeaveRequestLoading extends AdminLeaveRequestsState {
  final int id;
  const ApproveOrRejectAdminLeaveRequestLoading({required this.id});

  @override
  List<Object?> get props => [id];
}

class ApproveOrRejectAdminLeaveRequestSuccess extends AdminLeaveRequestsState {
  final int id;
  final String status;
  const ApproveOrRejectAdminLeaveRequestSuccess({required this.id, required this.status});

  @override
  List<Object?> get props => [id, status];
}

class ApproveOrRejectAdminLeaveRequestFailure extends AdminLeaveRequestsState {
  final String error;
  final int id;

  const ApproveOrRejectAdminLeaveRequestFailure({required this.error, required this.id});

  @override
  List<Object?> get props => [error, id];
}

class DeleteAdminLeaveRequestLoading extends AdminLeaveRequestsState {}

class DeleteAdminLeaveRequestSuccess extends AdminLeaveRequestsState {}

class DeleteAdminLeaveRequestFailure extends AdminLeaveRequestsState {
  final String error;

  const DeleteAdminLeaveRequestFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
