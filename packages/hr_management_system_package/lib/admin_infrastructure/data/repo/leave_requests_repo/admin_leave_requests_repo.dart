import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../supervisor_infrastructure/supervisor_data.dart';
import '../../../../supervisor_infrastructure/data/models/get_leave_Request_model/change_request_leave_status.dart';

abstract class AdminLeaveRequestsRepo {
  Future<Either<Failure, GetLeaveRequestModel>> getAllLeaveRequests();
  Future<Either<Failure, void>> approveOrRejectLeaveRequest({
    required ChangeRequestLeaveStatus body,
  });
  Future<Either<Failure, void>> deleteLeaveRequest({required int id});
}
