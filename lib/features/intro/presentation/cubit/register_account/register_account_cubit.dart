import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/register_account/repo/register_account_repo.dart';

part 'register_account_state.dart';

class RegisterAccountCubit extends Cubit<RegisterAccountState> {
  RegisterAccountCubit({required this.registerAccountRepo})
      : super(RegisterAccountInitial());

  final RegisterAccountRepo registerAccountRepo;

  Future<void> registerAccount({
    required String name,
    required String deviceToken,
  }) async {
    emit(RegisterAccountLoading());
    final result = await registerAccountRepo.registerAccount(
      name: name,
      deviceToken: deviceToken,
    );
    result.fold(
      (l) {
        if (!isClosed) emit(RegisterAccountFailure(errorMessage: l.message));
      },
      (r) {
        if (!isClosed) emit(RegisterAccountSuccess());
      },
    );
  }
}
