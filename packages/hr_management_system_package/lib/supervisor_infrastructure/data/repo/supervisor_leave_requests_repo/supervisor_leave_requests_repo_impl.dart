import 'package:dartz/dartz.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/get_leave_Request_model/change_request_leave_status.dart';

import '../../../../hr_manamgement_system_package.dart';
import 'supervisor_leave_requests_repo.dart';

class SupervisorLeaveRequestsRepoImpl implements SupervisorLeaveRequestsRepo {
  final ApiService apiservice;

  SupervisorLeaveRequestsRepoImpl({
    required this.apiservice,
  });
  @override
  // approve Or Reject LeaveRequest
  Future<Either<Failure, void>> approveOrRejectLeaveRequest(
      {required ChangeRequestLeaveStatus body}) async {
    try {
      final result = await apiservice.put(
        endPoint: "${ApiConstant.leaveRequest}/leaveRequestStatus",
        body: body.toJson(),
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
  // get LeaveRequests By Type
  Future<Either<Failure, GetLeaveRequestModel>>
      getLeaveRequestsByTypeForDepartment({required String type}) async {
    try {
      final result = await apiservice.get(
          endPoint:
              "${ApiConstant.leaveRequest}/departmentId/${ApiConstant.departmentId}/leaveType/$type");
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
  // get LeaveRequests
  Future<Either<Failure, List<GetLeaveRequestModel>>>
      supervisorGetEmployeeLeaveRequest() async {
    try {
      final result = await apiservice.get(endPoint: ApiConstant.leaveRequest);
      if (result[ApiConstant.successApiKey] == true) {
        return Right((result['value'] as List)
            .map((e) => GetLeaveRequestModel.fromJson(e))
            .toList());
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
