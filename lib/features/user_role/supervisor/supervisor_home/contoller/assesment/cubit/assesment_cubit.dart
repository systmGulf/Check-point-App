import 'package:bloc/bloc.dart';
import 'package:employee_mangement/core/base/async_value.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_assesment_model/assesment_input_model/assesment_input_model.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_assesment_model/assesment_model.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/assesment_repo/assesment_repo.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:meta/meta.dart';

part 'assesment_state.dart';

class AssesmentCubit extends Cubit<AsyncValue<AssesmentState>> {
  final AssesmentRepo _assesmentRepo;
  AssesmentCubit({required AssesmentRepo assesmentRepo})
      : _assesmentRepo = assesmentRepo,
        super(AsyncInitial());
  Future<void> getAssesments() async {
    emit(AsyncLoading());
    final result = await _assesmentRepo.getAssesments();
    result.fold((l) {
      emit(AsyncFailure(l.message));
    }, (assesments) {
      emit(AsyncSuccess(AssesmentState(assesmentModelList: assesments)));
    });
  }

  Future<void> getAssesmentById(String assesmentId) async {
    switch (state) {
      case AsyncSuccess(:final value):
        emit(
          AsyncSuccess(
            GeetAssesmentByIdLoadingState(
                assesmentModelList: value.assesmentModelList),
          ),
        );
        final result = await _assesmentRepo.getAssesmentsById(
            ApiConstant.employeeId.trim(), assesmentId);
        result.fold((l) {
          emit(AsyncSuccess(GetAssesmentByIdFailureState(
              msg: l.message, assesmentModelList: value.assesmentModelList)));
        }, (assesment) {
          emit(AsyncSuccess(GetAssesmentByIdSuccessState(
              assesmentModelList: value.assesmentModelList,
              assesment: assesment)));
        });
        break;
      default:
        break;
    }
  }

  Future<void> submitAssesment(AssesmentInputModel input) async {
    switch (state) {
      case AsyncSuccess(:final value):
        switch (value) {
          case GetAssesmentByIdSuccessState(
              :final assesment,
              :final assesmentModelList
            ):
            emit(
              AsyncSuccess(
                SubmitAssesmentLoadingState(
                  assesmentModelList: assesmentModelList,
                  assesment: assesment,
                ),
              ),
            );
            final result = await _assesmentRepo.submit(input);
            result.fold((l) {
              emit(AsyncSuccess(SubmitAssesmentFailureState(
                  msg: l.message,
                  assesmentModelList: value.assesmentModelList,
                  assesment: assesment)));
            }, (assesment) {
              emit(
                AsyncSuccess(
                  SubmitAssesmentSuccessState(
                      assesmentModelList: value.assesmentModelList,
                      assesment: assesment,
                      submitedAssesment: assesment),
                ),
              );
            });
            break;
          default:
            break;
        }
        break;
      default:
        break;
    }
  }
}
