import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

part 'leave_application_state.dart';

class LeaveApplicationCubitSupervisor extends Cubit<LeaveApplicationState> {
  final SupervisorRepo supervisorRepo;
  bool _isRequesting = false;
  int numOfLeaveRequest = 0;
  LeaveApplicationCubitSupervisor(this.supervisorRepo)
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
        numOfLeaveRequest = r.value!.data!.where((e) => e.status == 'Pending').length;

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
    emit(ApproveOrRejectLeaveApplicationLoading());
    final result = await supervisorRepo.approveOrRejectLeaveRequest(
      status: status,
      id: id,
    );
    result.fold(
      (l) {
        if (isClosed) return;
        _isRequesting = false;
        emit(ApproveOrRejectLeaveApplicationFailure(error: l.message));
      },
      (r) {
        if (isClosed) return;
        _isRequesting = false;
        emit(ApproveOrRejectLeaveApplicationSuccess());
      },
    );
  }
}
