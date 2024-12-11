import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:hr_management_system_package/core/common_methods/fcm_notification_service.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  Future<void> pushNotification() async {
    emit(NotificationLoading());
    try {
      FcmNotificationService.sendNotification(
          'systm Gulf', titleController.text, bodyController.text);
      emit(NotificationSuccess());
    } on Exception catch (e) {
      emit(NotificationError(error: e.toString()));
    }
  }
}
