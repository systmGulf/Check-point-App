part of 'shifts_and_polices_cubit.dart';

@immutable
abstract class ShiftsAndPolicesState {}

class ShiftsAndPolicesInitial extends ShiftsAndPolicesState {}

class AddShiftLoading extends ShiftsAndPolicesState {}

class AddShiftSuccess extends ShiftsAndPolicesState {}

class AddShiftError extends ShiftsAndPolicesState {
  final String error;

  AddShiftError({required this.error});
}

class GetShiftsLoading extends ShiftsAndPolicesState {}

class GetShiftsSuccess extends ShiftsAndPolicesState {
  final ShiftModel shiftModel;

  GetShiftsSuccess({required this.shiftModel});
}

class GetShiftsError extends ShiftsAndPolicesState {
  final String error;

  GetShiftsError({required this.error});
}

class DeleteShiftLoading extends ShiftsAndPolicesState {}

class DeleteShiftSuccess extends ShiftsAndPolicesState {}

class DeleteShiftError extends ShiftsAndPolicesState {
  final String error;

  DeleteShiftError({required this.error});
}

class GetPoliceByShiftIDLoading extends ShiftsAndPolicesState {}

class GetPoliceByShiftIDSuccess extends ShiftsAndPolicesState {
  final PoliceResponse policeResponse;

  GetPoliceByShiftIDSuccess({required this.policeResponse});
}

class GetPoliceByShiftIDError extends ShiftsAndPolicesState {
  final String error;

  GetPoliceByShiftIDError({required this.error});
}

class AddPoliceLoading extends ShiftsAndPolicesState {}

class AddPoliceSuccess extends ShiftsAndPolicesState{}
class AddPoliceFailure extends ShiftsAndPolicesState {
  final String error;

  AddPoliceFailure({required this.error});
}

class DeletePoliceLoading extends ShiftsAndPolicesState {}

class DeletePoliceSuccess extends ShiftsAndPolicesState{}

class DeletePoliceError extends ShiftsAndPolicesState {
  final String error;

  DeletePoliceError({required this.error});
}
class AssignShiftLoading extends ShiftsAndPolicesState {}

class AssignShiftSuccess extends ShiftsAndPolicesState{}

class AssignShiftError extends ShiftsAndPolicesState {
  final String error;

  AssignShiftError({required this.error});
}
class AssignPoliceLoading extends ShiftsAndPolicesState {}

class AssignPoliceSuccess extends ShiftsAndPolicesState{}

class AssignPoliceError extends ShiftsAndPolicesState {
  final String error;

  AssignPoliceError({required this.error});
}