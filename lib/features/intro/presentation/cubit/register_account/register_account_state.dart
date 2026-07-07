part of 'register_account_cubit.dart';

abstract class RegisterAccountState {}

class RegisterAccountInitial extends RegisterAccountState {}

class RegisterAccountLoading extends RegisterAccountState {}

class RegisterAccountSuccess extends RegisterAccountState {}

class RegisterAccountFailure extends RegisterAccountState {
  final String errorMessage;

  RegisterAccountFailure({required this.errorMessage});
}
