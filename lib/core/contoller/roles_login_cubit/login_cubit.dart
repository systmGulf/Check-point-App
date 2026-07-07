import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../enums/role_enum.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.loginRepo}) : super(LoginInitial());

  final LoginRepo loginRepo;

  Future<void> doLogin({
    required String email,
    required String password,
    required Role role,
    required String mobileId,
  }) async {
    emit(LoginLoading());
    final result = await loginRepo.roleLogin(
      RoleLoginRequestBody(
        email: email,
        password: password,
        mobileId: mobileId,
        role: role.name,
      ),
    );
    result.fold(
      (failure) {
        if (!isClosed) emit(LoginFailure(error: failure.message));
      },
      (employeeLoginModel) {
        if (!isClosed) emit(LoginSuccess(employeeLoginModel: employeeLoginModel));
      },
    );
  }

  Future<void> getEmployeeById() async {
    emit(GetEmployeeLoading());
    final result = await loginRepo.getEmployeeById();
    result.fold(
      (failure) {
        if (!isClosed) emit(GetEmployeeFailure(error: failure.message));
      },
      (employeeLoginModel) {
        if (!isClosed) {
          emit(GetEmployeeSuccess(employeeLoginModel: employeeLoginModel));
        }
      },
    );
  }
}
