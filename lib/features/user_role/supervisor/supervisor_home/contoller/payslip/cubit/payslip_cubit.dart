import 'package:bloc/bloc.dart';
import 'package:hr_management_system_package/core/networking/api_constant.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_payslip_model/payslip_model.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_payslip_repo/employee_payslip_repo.dart';
import 'package:meta/meta.dart';

part 'payslip_state.dart';

class PayslipCubit extends Cubit<PayslipState> {
  final EmployeePayslipRepo _repo;

  PayslipCubit({required EmployeePayslipRepo repo})
      : _repo = repo,
        super(PayslipInitial());
  Future<void> getPayslipById() async {
    emit(GetPayslipByIdLoadingState());
    final id = ApiConstant.employeeId.trim();
    final result = await _repo.getPayslipByEmployeeId(id);
    result.fold((l) {
      emit(GetPayslipByIdFailureState(msg: l.message));
    }, (paySlipModelList) {
      emit(GetPayslipByIdSuccessState(paySlipModelList: paySlipModelList));
    });
  }
}
