import 'package:dartz/dartz.dart';
import 'package:hr_management_system_package/core/notifications/notification_repo.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

class NotificationsRepoImpl implements NotificationRepo {
  final ApiService apiService;

  NotificationsRepoImpl({required this.apiService});
  @override
  Future<Either<Failure, void>> sendMultipleNotification(
      {required List<String> tokens,
      required String title,
      required String body,
      required String topic}) async {
    try {
      final requestBody = SendMultipleNotificationsRequestBody(
        deviceTokens: tokens,
        title: title,
        body: body,
        topic: topic,
      );
      final result = await apiService.post(
          endPoint:
              "${ApiConstant.notification}/${ApiConstant.multiNotification}",
          body: requestBody.toJson());
      if (result['isSuccess'] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> sendSingleNotification(
      {required String token,
      required String title,
      required String body}) async {
    try {
      final requestBody = SendSingleNotificationRequestBody(
        deviceToken: token,
        title: title,
        body: body,
      );
      final result = await apiService.post(
          endPoint:
              "${ApiConstant.notification}/${ApiConstant.singleNotification}",
          body: requestBody.toJson());
      if (result['isSuccess'] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
