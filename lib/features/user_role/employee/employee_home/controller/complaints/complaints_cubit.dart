import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hr_management_system_package/core/networking/api_constant.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/complaints/add_complaint_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/complaints/add_complaints_model.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/complaints/complaint_response_model.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/complaints/complaints_repo.dart';

part 'complaints_state.dart';

class ComplaintsCubit extends Cubit<ComplaintsState> {
  ComplaintsCubit(this.complaintsRepo) : super(ComplaintsInitial());

  final ComplaintsRepo complaintsRepo;

  Future<void> getComplaints() async {
    emit(GetComplaintsLoadingState());
    final result = await complaintsRepo.getComplaints();
    result.fold(
      (failure) => emit(GetComplaintsFailureState(failure.message)),
      (response) => emit(GetComplaintsSuccessState(response)),
    );
  }

  Future<void> addComplaint({
    required String subject,
    required String description,
  }) async {
    emit(AddComplaintLoading());
    final result = await complaintsRepo.addComplaint(
      AddComplaintRequestBody(
        subject: subject,
        description: description,
        employeeId: ApiConstant.employeeId,
      ),
    );
    result.fold(
      (failure) => emit(AddComplaintFailureState(failure.message)),
      (response) => emit(AddComplaintSuccess(response)),
    );
  }
}
