import 'package:dartz/dartz.dart';

import '../../../../hr_manamgement_system_package.dart';

abstract class BranchesRepo {
  // Get all branches Method
  Future<Either<Failure, BranchesPage>> getAllBranches();
  // Add new branch
  Future<Either<Failure, void>> addCompanyBranch(
      {required AddBrachRequestBody addBranchRequestBody});
  // Edit branch
  Future<Either<Failure, void>> editBranch({
    required int id,
    required AddBrachRequestBody addBranchRequestBody,
  });
  // Delete branch
  Future<Either<Failure, void>> deleteBranch({required int id});
}
