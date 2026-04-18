import 'package:hr_management_system_package/supervisor_infrastructure/data/models/feedbacks/feedback_model.dart'
    show FeedbackModel;

abstract class FeedbackState {}

final class FeedbackInitState extends FeedbackState {}

final class GetFeedbackLoadingState extends FeedbackState {}

final class GetFeedbackSuccessState extends FeedbackState {
  final FeedbackModel feedbackModel;

  GetFeedbackSuccessState({required this.feedbackModel});
}

final class GetFeedbackFilureState extends FeedbackState {
  final String errorMessage;

  GetFeedbackFilureState({required this.errorMessage});
}

final class AddFeedbackLoadingState extends FeedbackState {}

final class AddFeedbackSuccessState extends FeedbackState {
  AddFeedbackSuccessState();
}

final class AddFeedbackFailureState extends FeedbackState {
  final String errorMessage;

  AddFeedbackFailureState({required this.errorMessage});
}
