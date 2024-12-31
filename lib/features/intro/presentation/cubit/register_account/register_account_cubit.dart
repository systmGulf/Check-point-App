import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/register_account/repo/register_account_repo.dart';

part 'register_account_state.dart';

class RegisterAccountCubit extends Cubit<RegisterAccountState> {
  final RegisterAccountRepo registerAccountRepo;
  RegisterAccountCubit(this.registerAccountRepo)
      : super(RegisterAccountInitial());
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> registerAccount() async {
    emit(RegisterAccountLoading());
    final currentFCMToken = await FirebaseMessaging.instance.getToken();
    var result = await registerAccountRepo.registerAccount(
        name: nameController.text, deviceToken: currentFCMToken!);
    result.fold((l) {
      emit(RegisterAccountFailure(errorMessage: l.message));
    }, (r) {
      emit(RegisterAccountSuccess());
    });
  }
}
