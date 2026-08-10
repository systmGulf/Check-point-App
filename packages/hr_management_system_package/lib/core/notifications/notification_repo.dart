import 'package:dartz/dartz.dart';

import '../errors/error_handler.dart';

abstract class NotificationRepo {
  Future<Either<Failure, void>> sendSingleNotification(
      {required String token, required String title, required String body});
  Future<Either<Failure, void>> sendMultipleNotification(
      {required List<String> tokens,
      required String title,
      required String body, required String topic});
}
