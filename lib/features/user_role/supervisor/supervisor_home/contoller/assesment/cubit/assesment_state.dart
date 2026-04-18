part of 'assesment_cubit.dart';

@immutable
class AssesmentState {
  final List<EmployeeAssessmentModel> assesmentModelList;

  const AssesmentState({
    required this.assesmentModelList,
  });
}

final class GeetAssesmentByIdLoadingState extends AssesmentState {
  const GeetAssesmentByIdLoadingState({
    required super.assesmentModelList,
  });
}

final class GetAssesmentByIdFailureState extends AssesmentState {
  final String msg;
  const GetAssesmentByIdFailureState({
    required super.assesmentModelList,
    required this.msg,
  });
}

final class GetAssesmentByIdSuccessState extends AssesmentState {
  final EmployeeAssessmentModel assesment;
  const GetAssesmentByIdSuccessState({
    required super.assesmentModelList,
    required this.assesment,
  });
}

final class SubmitAssesmentLoadingState extends GetAssesmentByIdSuccessState {
  const SubmitAssesmentLoadingState({
    required super.assesmentModelList,
    required super.assesment,
  });
}

final class SubmitAssesmentFailureState extends GetAssesmentByIdSuccessState {
  final String msg;
  const SubmitAssesmentFailureState({
    required super.assesmentModelList,
    required super.assesment,
    required this.msg,
  });
}

final class SubmitAssesmentSuccessState extends GetAssesmentByIdSuccessState {
  final EmployeeAssessmentModel submitedAssesment;
  const SubmitAssesmentSuccessState({
    required super.assesmentModelList,
    required super.assesment,
    required this.submitedAssesment,
  });
}
