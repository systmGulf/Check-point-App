import 'package:hr_management_system_package/supervisor_infrastructure/data/models/surveys/employee_survey_reponse_model.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/surveys/submit_reponse_model.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/surveys/surveys_reponse_model.dart';

abstract class GetSurveysState {}

final class GetSurveysInitial extends GetSurveysState {}

final class GetSurveysLoadingState extends GetSurveysState {}

final class GetSurveysSuccessState extends GetSurveysState {
  final SurveyResponseModel surveyResponseModel;

  GetSurveysSuccessState({required this.surveyResponseModel});
}

final class GetSurveysFailureState extends GetSurveysState {
  final String errorMessage;

  GetSurveysFailureState({required this.errorMessage});
}

final class GetEmployeeSurveysLoadingState extends GetSurveysState {}

final class GetEmployeeSurveysSuccessState extends GetSurveysState {
  final EmployeeSurveyReponseModel employeeSurveyReponseModel;

  GetEmployeeSurveysSuccessState({required this.employeeSurveyReponseModel});
}

final class GetEmployeeSurveysFailureState extends GetSurveysState {
  final String errorMessage;

  GetEmployeeSurveysFailureState({required this.errorMessage});
}

final class SubmitSurveyLoadingState extends GetSurveysState {}

final class SubmitSurveySuccessState extends GetSurveysState {
  final SurveySubmitResponseModel surveySubmitResponseModel;

  SubmitSurveySuccessState({required this.surveySubmitResponseModel});
}

final class SubmitSurveyFailureState extends GetSurveysState {
  final String errorMessage;

  SubmitSurveyFailureState({required this.errorMessage});
}
