import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

part 'change_password_state.dart';

class EmployeeChangePasswordCubit extends Cubit<EmployeeChangePasswordState> {
  EmployeeChangePasswordCubit({required this.employeeRepo})
      : super(ChangePasswordInitial());

  final EmployeeActionRepo employeeRepo;

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoading());
    final result = await employeeRepo.employeeChangePassword(
      ChangePasswordRequestBody(
        employeeId: ApiConstant.employeeId,
        oldPassword: oldPassword,
        newPassword: newPassword,
      ),
    );
    result.fold(
      (l) {
        if (!isClosed) emit(ChangePasswordFailure(l.message));
      },
      (r) {
        if (!isClosed) emit(ChangePasswordSuccess());
      },
    );
  }
}
