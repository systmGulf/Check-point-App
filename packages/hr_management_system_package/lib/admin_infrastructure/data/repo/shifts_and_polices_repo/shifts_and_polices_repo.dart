import 'package:dartz/dartz.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/shifts_and_polices_model/assign_shifts_request_body.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/shifts_and_polices_model/get_police_by_shift_id.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../models/shifts_and_polices_model/add_police_request_body.dart';
import '../../models/shifts_and_polices_model/shifts_model.dart';

abstract class ShiftsAndPolicesRepo {
  /// shifts
  // add shift
  Future<Either<Failure, void>> addShift({required String shiftName});
  // edit shift
  Future<Either<Failure, void>> editShift({
    required int id,
    required String shiftName,
  });
  // get shifts
  Future<Either<Failure, ShiftModel>> getShifts();
  // delete shift
  Future<Either<Failure, void>> deleteShift({required int id});
  // assign shift
  Future<Either<Failure, void>> assignShift(
      {required AssignShiftsRequestBody assignShiftsRequestBody});

  /// police
  // add police
  Future<Either<Failure, void>> addPolice(
      {required AddPoliceRequestBody addPoliceRequestBody});
  // get police by shift id
  Future<Either<Failure, PoliceResponse>> getPoliceByShiftId(
      {required int shiftId});
  // delete police
  Future<Either<Failure, void>> deletePolice({required int id});
  // edit police
  Future<Either<Failure, void>> editPolice(
      {required AddPoliceRequestBody addPoliceRequestBody, required int id});
  // assign police
  Future<Either<Failure, void>> assignPolice(
      {required AssignPoliceRequestBody assignShiftsRequestBody});

  // Remove Assign Police
  Future<Either<Failure, String>> removeAssignPolice(
      {required RemoveAssignPolicyRequestBody remove});
}
