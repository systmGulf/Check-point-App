import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/repo/leave_requests_repo/admin_leave_requests_repo.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/get_leave_Request_model/change_request_leave_status.dart';

part 'admin_leave_requests_state.dart';

class AdminLeaveRequestsCubit extends Cubit<AdminLeaveRequestsState> {
  final AdminLeaveRequestsRepo adminLeaveRequestsRepo;
  bool _isRequesting = false;
  int numOfLeaveRequest = 0;

  AdminLeaveRequestsCubit({required this.adminLeaveRequestsRepo})
      : super(AdminLeaveRequestsInitial());

  Future<void> getAllLeaveRequests() async {
    if (_isRequesting) return;
    _isRequesting = true;

    emit(GetAllLeaveRequestsLoading());
    final result = await adminLeaveRequestsRepo.getAllLeaveRequests();
    result.fold(
      (l) {
        if (isClosed) return;
        _isRequesting = false;
        emit(GetAllLeaveRequestsFailure(error: l.message));
      },
      (r) {
        if (isClosed) return;
        _isRequesting = false;
        if (r.value?.data != null) {
          numOfLeaveRequest =
              r.value!.data!.where((e) => e.status == 'Pending').length;
        } else {
          numOfLeaveRequest = 0;
        }
        emit(GetAllLeaveRequestsSuccess(getLeaveRequestModel: r));
      },
    );
  }

  Future<void> approveOrRejectLeaveRequest({
    required String status,
    required int id,
  }) async {
    if (_isRequesting) return;
    _isRequesting = true;
    emit(ApproveOrRejectAdminLeaveRequestLoading(id: id));
    final result = await adminLeaveRequestsRepo.approveOrRejectLeaveRequest(
      body: ChangeRequestLeaveStatus(
        status: status,
        leaveRequestId: id,
      ),
    );
    result.fold(
      (l) {
        if (isClosed) return;
        _isRequesting = false;
        emit(ApproveOrRejectAdminLeaveRequestFailure(error: l.message, id: id));
      },
      (r) {
        if (isClosed) return;
        _isRequesting = false;
        emit(ApproveOrRejectAdminLeaveRequestSuccess(id: id, status: status));
        getAllLeaveRequests();
      },
    );
  }

  Future<void> deleteLeaveRequest({required int id}) async {
    if (_isRequesting) return;
    _isRequesting = true;
    emit(DeleteAdminLeaveRequestLoading());
    final result = await adminLeaveRequestsRepo.deleteLeaveRequest(id: id);
    result.fold(
      (l) {
        if (isClosed) return;
        _isRequesting = false;
        emit(DeleteAdminLeaveRequestFailure(error: l.message));
      },
      (r) {
        if (isClosed) return;
        _isRequesting = false;
        emit(DeleteAdminLeaveRequestSuccess());
        getAllLeaveRequests();
      },
    );
  }
}
