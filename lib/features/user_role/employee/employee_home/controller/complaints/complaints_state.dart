part of 'complaints_cubit.dart';

abstract class ComplaintsState extends Equatable {
  const ComplaintsState();

  @override
  List<Object?> get props => [];
}

class ComplaintsInitial extends ComplaintsState {}

class GetComplaintsLoadingState extends ComplaintsState {}

class GetComplaintsSuccessState extends ComplaintsState {
  const GetComplaintsSuccessState(this.complaints);

  final ComplaintResponseModel complaints;

  @override
  List<Object?> get props => [complaints];
}

class GetComplaintsFailureState extends ComplaintsState {
  const GetComplaintsFailureState(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}

class AddComplaintLoading extends ComplaintsState {}

class AddComplaintSuccess extends ComplaintsState {
  const AddComplaintSuccess(this.response);

  final AddComplaintsModel response;

  @override
  List<Object?> get props => [response];
}

class AddComplaintFailureState extends ComplaintsState {
  const AddComplaintFailureState(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
