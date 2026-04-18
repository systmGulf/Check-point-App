part of 'payslip_cubit.dart';

@immutable
sealed class PayslipState {}

final class PayslipInitial extends PayslipState {}

final class GetPayslipByIdLoadingState extends PayslipState {}

final class GetPayslipByIdFailureState extends PayslipState {
  final String msg;

  GetPayslipByIdFailureState({required this.msg});
}

final class GetPayslipByIdSuccessState extends PayslipState {
  final List<PayrollModel> paySlipModelList;

  GetPayslipByIdSuccessState({required this.paySlipModelList});
}
