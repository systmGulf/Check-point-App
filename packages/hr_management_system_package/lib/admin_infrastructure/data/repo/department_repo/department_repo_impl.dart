import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';

import '../../../../core/networking/api_constant.dart';
import '../../../../core/networking/api_service.dart';
import '../../models/department_model/department_model.dart';
import '../../models/department_model/department_request_body.dart';
import 'department_repo.dart';

class DepartmentRepoImpl implements DepartmentRepo {
  final ApiService apiService;

  DepartmentRepoImpl({
    required this.apiService,
  });

  @override
  // Add Department
  Future<Either<Failure, void>> addDepartment(
      {required String departmentName}) async {
    try {
      final requestBody = DepartmentRequestBody(
        departmentName: departmentName,
      );
      final result = await apiService.post(
          endPoint: ApiConstant.department,
          body: requestBody.toJson());
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
  // Delete Department
  Future<Either<Failure, void>> deleteDepartment({required int id}) async {
    try {
      final result =
          await apiService.delete(endPoint: "${ApiConstant.department}?id=$id");
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
  // Get all Department
  Future<Either<Failure, DepartmentsPage>> getAllDepartments(
      {required int pageKey, required int pageSize}) async {
    try {
      final result = await apiService.get(
          endPoint:
              "${ApiConstant.department}?itemCount=$pageSize&index=${pageKey * 10}");
      if (result[ApiConstant.successApiKey] == true) {
        final response = DepartmentModel.fromJson(result);
        return Right(response.departmentsPageOrEmpty);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Search Department
  Future<Either<Failure, DepartmentsPage>> searchDepartments(
      {required String searchKey}) async {
    try {
      final result = await apiService.get(
          endPoint: "${ApiConstant.department}/search/$searchKey");
      if (result[ApiConstant.successApiKey] == true) {
        final response = DepartmentModel.fromJson(result);
        return Right(response.departmentsPageOrEmpty);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Edit Department
  Future<Either<Failure, void>> editDepartment(
      {required int id, required String departmentName}) async {
    try {
      final requestBody = DepartmentRequestBody(
        departmentName: departmentName,
      );
      final result = await apiService.put(
          endPoint: "${ApiConstant.department}/$id",
          body: requestBody.toJson());
      if (result[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
