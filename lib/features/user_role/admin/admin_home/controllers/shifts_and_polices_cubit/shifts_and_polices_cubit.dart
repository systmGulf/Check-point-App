import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/admin/data/models/shifts_and_polices_model/shifts_model.dart';
import 'package:hr_management_system_package/admin/data/repo/shifts_and_polices_repo/shifts_and_polices_repo.dart';

part 'shifts_and_polices_state.dart';

class ShiftsAndPolicesCubit extends Cubit<ShiftsAndPolicesState> {
  final ShiftsAndPolicesRepo shiftsAndPolicesRepo;
  ShiftsAndPolicesCubit(this.shiftsAndPolicesRepo)
      : super(ShiftsAndPolicesInitial());
  final TextEditingController shiftNameController = TextEditingController();

  Future<void> addShift() async {
    emit(AddShiftLoading());
    final result = await shiftsAndPolicesRepo.addShift(
        shiftName: shiftNameController.text);
    result.fold((l) {
      emit(AddShiftError(error: l.message));
    }, (r) {
      emit(AddShiftSuccess());
    });
  }

  Future<void> getShifts() async {
    emit(GetShiftsLoading());
    final result = await shiftsAndPolicesRepo.getShifts();
    result.fold((l) {
      emit(GetShiftsError(error: l.message));
    }, (r) {
      emit(GetShiftsSuccess(shiftModel: r));
    });
  } 
}
