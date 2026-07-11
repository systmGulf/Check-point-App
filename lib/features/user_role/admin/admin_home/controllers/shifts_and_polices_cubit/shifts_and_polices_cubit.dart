import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/shifts_and_polices_model/add_police_request_body.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/shifts_and_polices_model/assign_shifts_request_body.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/shifts_and_polices_model/get_police_by_shift_id.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/shifts_and_polices_model/shifts_model.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/repo/shifts_and_polices_repo/shifts_and_polices_repo.dart';

part 'shifts_and_polices_state.dart';

class ShiftsAndPolicesCubit extends Cubit<ShiftsAndPolicesState> {
  final ShiftsAndPolicesRepo shiftsAndPolicesRepo;
  ShiftsAndPolicesCubit({required this.shiftsAndPolicesRepo})
      : super(ShiftsAndPolicesInitial());
  final TextEditingController shiftNameController = TextEditingController();
  String mounth = '';
  String year = '';
  String clockInTime = '';
  String clockOutTime = '';
  int shiftId = 00;

  void resetShiftForm() {
    shiftNameController.clear();
  }

  void setPoliceForm({
    required String month,
    required String year,
    required String clockInTime,
    required String clockOutTime,
  }) {
    mounth = month;
    this.year = year;
    this.clockInTime = clockInTime;
    this.clockOutTime = clockOutTime;
  }

  // add shift
  Future<void> addShift() async {
    emit(AddShiftLoading());
    final result = await shiftsAndPolicesRepo.addShift(
        shiftName: shiftNameController.text);
    result.fold((l) {
      emit(AddShiftError(error: l.message));
    }, (r) {
      getShifts(isLoading: false);
      emit(AddShiftSuccess());
    });
  }

  Future<void> editShift({required int id}) async {
    emit(EditShiftLoading());
    final result = await shiftsAndPolicesRepo.editShift(
      id: id,
      shiftName: shiftNameController.text,
    );
    result.fold((l) {
      emit(EditShiftError(error: l.message));
    }, (r) {
      getShifts(isLoading: false);
      emit(EditShiftSuccess());
    });
  }

  // get shifts
  Future<void> getShifts({required bool isLoading}) async {
    if (isLoading) emit(GetShiftsLoading());
    final result = await shiftsAndPolicesRepo.getShifts();
    result.fold((l) {
      emit(GetShiftsError(error: l.message));
    }, (r) {
      emit(GetShiftsSuccess(shiftModel: r));
    });
  }

  // delete shift
  Future<void> deleteShift({required int id}) async {
    emit(DeleteShiftLoading());
    final result = await shiftsAndPolicesRepo.deleteShift(id: id);
    result.fold((l) {
      emit(DeleteShiftError(error: l.message));
    }, (r) {
      getShifts(
        isLoading: false,
      );
      emit(DeleteShiftSuccess());
    });
  }
  // get police by shift id

  Future<void> getPoliceByShiftId(
      {required int shiftId, required bool isLoading}) async {
    if (isLoading) emit(GetPoliceByShiftIDLoading());
    try {
      final result =
          await shiftsAndPolicesRepo.getPoliceByShiftId(shiftId: shiftId);
      result.fold((l) {
        emit(GetPoliceByShiftIDError(error: l.message));
      }, (response) {
        emit(GetPoliceByShiftIDSuccess(policeResponse: response));
      });
    } on Exception catch (e) {
      emit(GetPoliceByShiftIDError(error: e.toString()));
    }
  }

  // add police
  Future<void> addPolice() async {
    emit(AddPoliceLoading());
    final result = await shiftsAndPolicesRepo.addPolice(
        addPoliceRequestBody: AddPoliceRequestBody(
            month: mounth,
            year: year,
            clockInTime: clockInTime,
            clockOutTime: clockOutTime,
            shiftId: shiftId.toString(),
            area: "Office"));
    result.fold((errorMassage) {
      emit(AddPoliceFailure(error: errorMassage.message));
    }, (r) {
      getPoliceByShiftId(shiftId: shiftId, isLoading: false);
      emit(AddPoliceSuccess());
    });
  }

  Future<void> editPolice({required int id}) async {
    emit(EditPoliceLoading());
    final result = await shiftsAndPolicesRepo.editPolice(
      id: id,
      addPoliceRequestBody: AddPoliceRequestBody(
        month: mounth,
        year: year,
        clockInTime: clockInTime,
        clockOutTime: clockOutTime,
        shiftId: shiftId.toString(),
        area: "Office",
      ),
    );
    result.fold((errorMassage) {
      emit(EditPoliceFailure(error: errorMassage.message));
    }, (r) {
      getPoliceByShiftId(shiftId: shiftId, isLoading: false);
      emit(EditPoliceSuccess());
    });
  }

  // delete police
  Future<void> deletePolice({required int id}) async {
    emit(DeletePoliceLoading());
    final result = await shiftsAndPolicesRepo.deletePolice(id: id);
    result.fold((l) {
      emit(DeletePoliceError(error: l.message));
    }, (r) {
      getPoliceByShiftId(shiftId: shiftId, isLoading: false);
      emit(DeletePoliceSuccess());
    });
  }

  // assign Shift
  List<int> branchesIds = [];
  Future<void> assignBranchesToShift({required int shiftId}) async {
    emit(AssignShiftLoading());
    if (branchesIds.isNotEmpty) {
      final result = await shiftsAndPolicesRepo.assignShift(
          assignShiftsRequestBody: AssignShiftsRequestBody(
              shiftId: shiftId, branchesIds: branchesIds));
      result.fold((l) {
        emit(AssignShiftError(error: l.message));
      }, (r) {
        getShifts(isLoading: false);
        branchesIds = [];
        emit(AssignShiftSuccess());
      });
    } else {
      emit(AssignShiftError(error: "Select Branches First"));
    }
  }

  List<String> employeesIds = [];
  // assign Police
  Future<void> assignEmployeesToPolice({required int policeId}) async {
    emit(AssignPoliceLoading());
    if (employeesIds.isNotEmpty) {
      final result = await shiftsAndPolicesRepo.assignPolice(
          assignShiftsRequestBody: AssignPoliceRequestBody(
              policyId: policeId, employeeIds: employeesIds));
      result.fold((l) {
        emit(AssignPoliceError(error: l.message));
      }, (r) {
        getPoliceByShiftId(shiftId: shiftId, isLoading: false);
        employeesIds = [];
        emit(AssignPoliceSuccess());
      });
    } else {
      emit(AssignPoliceError(error: "Select Employees First"));
    }
  }

  // remove assign policy
  Future<void> removeAssignPolicy(
      {required int policeId, required String employeeId}) async {
    emit(RemoveAssignPolicyLoadingState());
    final result = await shiftsAndPolicesRepo.removeAssignPolice(
        remove: RemoveAssignPolicyRequestBody(
            policyId: policeId, employeeId: employeeId));
    result.fold((l) {
      emit(RemoveAssignPolicyFailureState(error: l.message));
    }, (r) {
      getPoliceByShiftId(shiftId: shiftId, isLoading: false);
      emit(RemoveAssignPolicySuccessState(message: r));
    });
  }

  @override
  Future<void> close() {
    shiftNameController.dispose();
    return super.close();
  }
}
