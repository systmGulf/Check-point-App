import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/feedback/feedback_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/feedbacks/add_feedback_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/feedback/feedback_repo.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final FeedbackRepository repository;

  FeedbackCubit(this.repository) : super(FeedbackInitState());

  Future<void> getFeedback() async {
    emit(GetFeedbackLoadingState());

    try {
      final data = await repository.getFeedbacks();

      data.fold((failure) {
        emit(GetFeedbackFilureState(errorMessage: failure.message));
      }, (success) {
        emit(GetFeedbackSuccessState(feedbackModel: success));
      });
    } catch (e) {
      emit(GetFeedbackFilureState(errorMessage: e.toString()));
    }
  }

  Future<void> addFeedback(AddFeedbackRequest request) async {
    emit(AddFeedbackLoadingState());

    try {
      final result = await repository.addFeedback(request);
      result.fold((fail) {
        emit(AddFeedbackFailureState(errorMessage: fail.message));
      }, (success) {
        emit(AddFeedbackSuccessState());

        getFeedback();
      });
    } catch (e) {
      emit(AddFeedbackFailureState(errorMessage: e.toString()));
    }
  }
}
