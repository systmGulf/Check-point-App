import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  Future<void> pushNotification() async {
    emit(NotificationLoading());
    try {
      // FcmNotificationService.sendNotification(
      //     'systm Gulf', titleController.text, bodyController.text);
      emit(NotificationSuccess());
    } on Exception catch (e) {
      emit(NotificationError(error: e.toString()));
    }
  }
}
