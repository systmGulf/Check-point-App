part of 'attendence_cubit.dart';

@immutable
abstract class AttendanceState {}

class AuthenticationInitial extends AttendanceState {}

class AuthenticationSuccess extends AttendanceState {}

class AuthenticationFailed extends AttendanceState {}

class AuthenticationLoading extends AttendanceState {}

class PickImageSuccess extends AttendanceState {}

class PickImageFailed extends AttendanceState {}

class PickImageLoading extends AttendanceState {}

class AttendanceIneDone extends AttendanceState {
  final UserAttendanceModel userAttendanceModel;
  AttendanceIneDone(this.userAttendanceModel);
}

class AttendanceIneLoading extends AttendanceState {}

class AttendanceInError extends AttendanceState {
  final String error;
  AttendanceInError(this.error);
}

class AttendanceOutedDone extends AttendanceState {
  final UserAttendanceModel userAttendanceModel;
  AttendanceOutedDone(this.userAttendanceModel);
}

class AttendanceOutLoading extends AttendanceState {}

class AttendanceOutError extends AttendanceState {
  final String error;
  AttendanceOutError(this.error);
}

class PermissionAttendanceField extends AttendanceState {}

class GetUserBranchLoading extends AttendanceState {}

class GetUserBranchDone extends AttendanceState {
  final GetBranchesData departmentModel;
  GetUserBranchDone(this.departmentModel);
}

class GetUserBranchError extends AttendanceState {
  final String error;
  GetUserBranchError(this.error);
}

class GetCustomerAreaLoading extends AttendanceState {}

class GetCustomerAreaDone extends AttendanceState {
  final EmployeePlansModel customerArea;
  GetCustomerAreaDone(this.customerArea);
}

class GetCustomerAreaError extends AttendanceState {
  final String error;
  GetCustomerAreaError(this.error);
}

class AccessAbleAreaState extends AttendanceState {}

class AccessAbleAreaErrorState extends AttendanceState {}

class GetPlanByIdLoading extends AttendanceState {}

class GetPlanByIdIdDone extends AttendanceState {
  final GetPlanByIdValue plansById;
  GetPlanByIdIdDone(this.plansById);
}

class GetPlanByIdError extends AttendanceState {
  final String error;
  GetPlanByIdError(this.error);
}

class AddPlanFeedbackLoading extends AttendanceState {}

class AddPlanFeedbackDone extends AttendanceState {}

class AddPlanFeedbackError extends AttendanceState {
  final String error;
  AddPlanFeedbackError(this.error);
}

class RemoveAssignCustomerPlanLoadingState extends AttendanceState {}

class RemoveAssignCustomerPlanSuccessState extends AttendanceState {}

class RemoveAssignCustomerPlanFailureState extends AttendanceState {
  final String error;

  RemoveAssignCustomerPlanFailureState(this.error);
}

class GetFeedBackStatusLoadingState extends AccessAbleAreaState {}

class GetFeedBackStatusSuccessState extends AccessAbleAreaState {
  final List<String> status;

  GetFeedBackStatusSuccessState(this.status);
}

class GetFeedBackStatusFailureState extends AccessAbleAreaState {
  final String error;

  GetFeedBackStatusFailureState(this.error);
}
