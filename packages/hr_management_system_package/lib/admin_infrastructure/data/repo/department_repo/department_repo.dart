import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../models/department_model/department_model.dart';

abstract class DepartmentRepo {
  // Add New Department
  Future<Either<Failure, void>> addDepartment({
    required String departmentName,
  });
  // Delete Department
  Future<Either<Failure, void>> deleteDepartment({
    required int id,
  });
  // Get all Department
  Future<Either<Failure, DepartmentsPage>> getAllDepartments(
      {required int pageKey, required int pageSize});
  // Search Department
  Future<Either<Failure, DepartmentsPage>> searchDepartments({
    required String searchKey,
  });
  // Edit Department
  Future<Either<Failure, void>> editDepartment({
    required int id,
    required String departmentName,
  });
}
