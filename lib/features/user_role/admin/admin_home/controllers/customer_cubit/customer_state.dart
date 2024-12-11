part of 'customer_cubit.dart';

@immutable
abstract class CustomerState {}

class CustomerInitial extends CustomerState {}

class AddCustomerLoading extends CustomerState {}

class AddCustomerSuccess extends CustomerState {}

class AddCustomerError extends CustomerState {
  final String error;
  AddCustomerError({required this.error});
}

class GetAllCustomersLoading extends CustomerState {}

class GetAllCustomersSuccess extends CustomerState {
  final CustomerValue customers;

  GetAllCustomersSuccess({required this.customers});
}

class GetAllCustomersError extends CustomerState {
  final String error;
  GetAllCustomersError({required this.error});
}

class DeleteCustomerLoading extends CustomerState {}

class DeleteCustomerSuccess extends CustomerState {}

class DeleteCustomerError extends CustomerState {
  final String error; 
  DeleteCustomerError({required this.error});
}

class EditCustomerLoading extends CustomerState {}

class EditCustomerSuccess extends CustomerState {}

class EditCustomerError extends CustomerState {
  final String error; 
  EditCustomerError({required this.error});
}
