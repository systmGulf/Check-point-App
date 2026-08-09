import 'package:dartz/dartz.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/shifts_and_polices_model/add_police_request_body.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/shifts_and_polices_model/assign_shifts_request_body.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/shifts_and_polices_model/get_police_by_shift_id.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/shifts_and_polices_model/shifts_model.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/repo/shifts_and_polices_repo/shifts_and_polices_repo.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

class ShiftsAndPolicesRepoImpl implements ShiftsAndPolicesRepo {
  final ApiService apiService;

  ShiftsAndPolicesRepoImpl({
    required this.apiService,
  });

  @override

  // Add new shift

  Future<Either<Failure, void>> addShift({required String shiftName}) async {
    try {
      final requestBody = AddShiftRequestBody(name: shiftName);
      final result = await apiService.post(
        endPoint: ApiConstant.shift,
        body: requestBody.toJson(),
      );
      if (result[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> editShift({
    required int id,
    required String shiftName,
  }) async {
    try {
      final requestBody = AddShiftRequestBody(name: shiftName);
      final result = await apiService.put(
        endPoint: "${ApiConstant.shift}/$id",
        body: requestBody.toJson(),
      );
      if (result[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // get all shifts
  Future<Either<Failure, ShiftModel>> getShifts() async {
    try {
      final result = await apiService.get(endPoint: ApiConstant.shift);
      if (result[ApiConstant.successApiKey] == true) {
        return Right(ShiftModel.fromJson(result));
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // delete shift
  Future<Either<Failure, void>> deleteShift({required int id}) async {
    try {
      final result =
          await apiService.delete(endPoint: "${ApiConstant.shift}?id=$id");
      if (result[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // add new police
  Future<Either<Failure, void>> addPolice(
      {required AddPoliceRequestBody addPoliceRequestBody}) async {
    try {
      final result = await apiService.post(
          endPoint: ApiConstant.policy, body: addPoliceRequestBody.toJson());
      if (result[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // get police by shift id
  Future<Either<Failure, PoliceResponse>> getPoliceByShiftId(
      {required int shiftId}) async {
    try {
      final result = await apiService.get(
          endPoint: "${ApiConstant.policy}/shift/$shiftId");
      if (result[ApiConstant.successApiKey] == true) {
        return Right(PoliceResponse.fromJson(result));
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // delete police
  Future<Either<Failure, void>> deletePolice({required int id}) async {
    try {
      final result =
          await apiService.delete(endPoint: "${ApiConstant.policy}?id=$id");
      if (result[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // edit police
  Future<Either<Failure, void>> editPolice(
      {required AddPoliceRequestBody addPoliceRequestBody,
      required int id}) async {
    try {
      final result = await apiService.put(
          endPoint: "${ApiConstant.policy}/$id",
          body: addPoliceRequestBody.toJson());
      if (result[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // assign shift
  Future<Either<Failure, void>> assignShift(
      {required AssignShiftsRequestBody assignShiftsRequestBody}) async {
    try {
      final result = await apiService.post(
          endPoint: "${ApiConstant.shift}/assignShift",
          body: assignShiftsRequestBody.toJson());
      if (result[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
// assign police
  Future<Either<Failure, void>> assignPolice(
      {required AssignPoliceRequestBody assignShiftsRequestBody}) async {
    try {
      final result = await apiService.post(
          endPoint: "${ApiConstant.policy}/assignPolicy",
          body: assignShiftsRequestBody.toJson());
      if (result[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, String>> removeAssignPolice(
      {required RemoveAssignPolicyRequestBody remove}) async {
    try {
      final response = await apiService.post(
          endPoint: ApiConstant.removeAsignPolicy, body: remove.toJson());

      if (response[ApiConstant.successApiKey] == true) {
        return Right(response['successMessage']);
      } else {
        return Left(ErrorHandler.responseFailure(response));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
