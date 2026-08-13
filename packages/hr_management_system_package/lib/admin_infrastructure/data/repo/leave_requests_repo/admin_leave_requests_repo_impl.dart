import 'package:dartz/dartz.dart';
import '../../../../hr_manamgement_system_package.dart';
import '../../../../supervisor_infrastructure/data/models/get_leave_Request_model/change_request_leave_status.dart';

class AdminLeaveRequestsRepoImpl implements AdminLeaveRequestsRepo {
  final ApiService apiservice;

  AdminLeaveRequestsRepoImpl({required this.apiservice});

  @override
  Future<Either<Failure, GetLeaveRequestModel>> getAllLeaveRequests() async {
    try {
      final result = await apiservice.get(endPoint: ApiConstant.leaveRequest);
      if (result[ApiConstant.successApiKey] == true) {
        return Right(GetLeaveRequestModel.fromJson(result));
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> approveOrRejectLeaveRequest(
      {required ChangeRequestLeaveStatus body}) async {
    try {
      final result = await apiservice.put(
        endPoint: "${ApiConstant.leaveRequest}/leaveRequestStatus/${body.leaveRequestId}/${body.status}",
        body: const {},
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
  Future<Either<Failure, void>> deleteLeaveRequest({required int id}) async {
    try {
      final result =
          await apiservice.delete(endPoint: "${ApiConstant.leaveRequest}/$id");
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
