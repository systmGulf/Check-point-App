import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/surveys/surveys_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/surveys/employee_survey_reponse_model.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/surveys/submit_survey_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/surveys/surveys_reponse_model.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/surveys/surveys_repo.dart';

class SurveysCubit extends Cubit<GetSurveysState> {
  final SurveysRepo surveysRepo;
  SurveyResponseModel? surveysCache;
  EmployeeSurveyReponseModel? employeeSurveysCache;

  SurveysCubit({required this.surveysRepo}) : super(GetSurveysInitial());

  /// Get all surveys
  Future<void> getAllSurveys() async {
    emit(GetSurveysLoadingState());

    final result = await surveysRepo.getSurveys();

    result.fold(
      (failure) => emit(GetSurveysFailureState(errorMessage: failure.message)),
      (success) {
        surveysCache = success;
        emit(GetSurveysSuccessState(surveyResponseModel: success));
      },
    );
  }

  // Get employee surveys
  Future<void> getEmployeeSurveys() async {
    emit(GetEmployeeSurveysLoadingState());

    final result = await surveysRepo.getSurveyByEmployeeId();

    result.fold(
      (failure) =>
          emit(GetEmployeeSurveysFailureState(errorMessage: failure.message)),
      (success) {
        employeeSurveysCache = success;
        emit(GetEmployeeSurveysSuccessState(employeeSurveyReponseModel: success));
      },
    );
  }

  // Submit survey
  Future<void> submitSurvey(
      {required SubmitSurveyRequestBody requestBody}) async {
    emit(SubmitSurveyLoadingState());

    final result = await surveysRepo.submitSurvey(requestBody: requestBody);

    result.fold(
      (failure) =>
          emit(SubmitSurveyFailureState(errorMessage: failure.message)),
      (success) =>
          emit(SubmitSurveySuccessState(surveySubmitResponseModel: success)),
    );
  }
}
