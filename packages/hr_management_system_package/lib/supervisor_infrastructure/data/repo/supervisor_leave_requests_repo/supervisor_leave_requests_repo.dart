import 'package:dartz/dartz.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/get_leave_Request_model/change_request_leave_status.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../supervisor_data.dart';

abstract class SupervisorLeaveRequestsRepo {
  // Supervisor Get Employee Leave Request
  Future<Either<Failure, List<GetLeaveRequestModel>>>
      supervisorGetEmployeeLeaveRequest();
  // Approve or reject leave request
  Future<Either<Failure, void>> approveOrRejectLeaveRequest({
    required ChangeRequestLeaveStatus body,
  });
  // Get leave requests by type
  Future<Either<Failure, GetLeaveRequestModel>>
      getLeaveRequestsByTypeForDepartment({
    required String type,
  });
}
