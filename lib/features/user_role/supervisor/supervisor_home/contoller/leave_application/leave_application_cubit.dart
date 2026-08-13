import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/get_leave_Request_model/change_request_leave_status.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/supervisor_leave_requests_repo/supervisor_leave_requests_repo.dart';

part 'leave_application_state.dart';

class LeaveApplicationCubitSupervisor extends Cubit<LeaveApplicationState> {
  final SupervisorLeaveRequestsRepo supervisorRepo;
  bool _isRequesting = false;
  int numOfLeaveRequest = 0;
  LeaveApplicationCubitSupervisor({required this.supervisorRepo})
      : super(LeaveApplicationInitial());

  Future<void> getLeaveApplication({
    required String type,
  }) async {
    if (_isRequesting) return;
    _isRequesting = true;

    emit(GetLeaveApplicationLoading());
    final result = await supervisorRepo.getLeaveRequestsByTypeForDepartment(
      type: type,
    );
    result.fold(
      (l) {
        if (isClosed) return;
        _isRequesting = false;
        emit(GetLeaveApplicationFailure(error: l.message));
      },
      (r) {
        if (isClosed) return;
        _isRequesting = false;
        numOfLeaveRequest =
            r.value!.data!.where((e) => e.status == 'Pending').length;

        emit(GetLeaveApplicationSuccess(getLeaveRequestModel: r));
      },
    );
  }

  Future<void> approveOrRejectLeaveRequest({
    required String status,
    required int id,
  }) async {
    if (_isRequesting) return;
    _isRequesting = true;
    emit(ApproveOrRejectLeaveApplicationLoading(id: id));
    final result = await supervisorRepo.approveOrRejectLeaveRequest(
      body: ChangeRequestLeaveStatus(
        leaveRequestId: id,
        status: status,
      ),
    );
    result.fold(
      (l) {
        if (isClosed) return;
        _isRequesting = false;
        emit(ApproveOrRejectLeaveApplicationFailure(error: l.message, id: id));
      },
      (r) {
        if (isClosed) return;
        _isRequesting = false;
        emit(ApproveOrRejectLeaveApplicationSuccess(id: id, status: status));
      },
    );
  }
}
