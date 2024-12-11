part of 'branch_cubit.dart';

@immutable
sealed class BranchState {}

class GetBranchLoading extends BranchState {}

class GetBranchSuccess extends BranchState {
  final GetBranchesValue branches;
  GetBranchSuccess({required this.branches});
}

class GetBranchError extends BranchState {
  final String error;
  GetBranchError({required this.error});
}


final class BranchInitial extends BranchState {}

final class AddBranchLoading extends BranchState {}

final class AddBranchSuccess extends BranchState {}

final class AddBranchError extends BranchState {

  final String error;

  AddBranchError({required this.error});

}
final class DeleteBranchSuccess extends BranchState {}

final class DeleteBranchError extends BranchState {
  final String error;
  DeleteBranchError({required this.error});
}
 final class DeleteBranchLoading extends BranchState {}
