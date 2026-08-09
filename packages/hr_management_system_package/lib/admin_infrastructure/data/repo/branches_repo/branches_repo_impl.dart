import 'package:dartz/dartz.dart';

import '../../../../hr_manamgement_system_package.dart';

class AdminRepoImpl implements BranchesRepo {
  final ApiService apiService;

  AdminRepoImpl({required this.apiService});

  @override
  // add company branch
  Future<Either<Failure, void>> addCompanyBranch(
      {required AddBrachRequestBody addBranchRequestBody}) async {
    try {
      final result = await apiService.post(
          endPoint: ApiConstant.branches, body: addBranchRequestBody.toJson());
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
  Future<Either<Failure, void>> editBranch({
    required int id,
    required AddBrachRequestBody addBranchRequestBody,
  }) async {
    try {
      final result = await apiService.put(
        endPoint: "${ApiConstant.branches}/$id",
        body: addBranchRequestBody.toJson(),
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
  // get all branches
  Future<Either<Failure, BranchesPage>> getAllBranches() async {
    try {
      final result = await apiService.get(endPoint: ApiConstant.branches);
      if (result[ApiConstant.successApiKey] == true) {
        final response = GetBranchesModel.fromJson(result);
        return Right(response.branchesPageOrEmpty);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // delete branch
  Future<Either<Failure, void>> deleteBranch({required int id}) async {
    try {
      final result =
          await apiService.delete(endPoint: "${ApiConstant.branches}/$id");
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
