import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../enums/role_enum.dart';
import '../../services/biometric_login_service.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.loginRepo,
    required this.biometricLoginService,
  }) : super(LoginInitial());

  final LoginRepo loginRepo;
  final BiometricLoginService biometricLoginService;

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

    await result.fold(
      (failure) async {
        if (!isClosed) emit(LoginFailure(error: failure.message));
      },
      (employeeLoginModel) async {
        await biometricLoginService.saveAccount(
          email: email,
          password: password,
          role: role,
        );
        if (!isClosed) {
          emit(LoginSuccess(employeeLoginModel: employeeLoginModel));
        }
      },
    );
  }

  Future<SavedLoginAccount?> getSavedLoginForRole(Role role) {
    return biometricLoginService.getSavedAccount(role);
  }

  Future<bool> canUseBiometricLogin(Role role) async {
    final hasSavedAccount = await biometricLoginService.hasSavedAccount(role);
    if (!hasSavedAccount) {
      return false;
    }
    return biometricLoginService.isBiometricAvailable();
  }

  Future<BiometricLoginResult> loginWithBiometrics({
    required Role role,
    required String mobileId,
  }) async {
    final account = await biometricLoginService.getSavedAccount(role);
    if (account == null) {
      return BiometricLoginResult.noSavedAccount;
    }

    final isBiometricAvailable =
        await biometricLoginService.isBiometricAvailable();
    if (!isBiometricAvailable) {
      return BiometricLoginResult.unavailable;
    }

    final isAuthenticated = await biometricLoginService.authenticate();
    if (!isAuthenticated) {
      return BiometricLoginResult.cancelled;
    }

    await doLogin(
      email: account.email,
      password: account.password,
      role: role,
      mobileId: mobileId,
    );
    return BiometricLoginResult.started;
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
