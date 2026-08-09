import 'package:dartz/dartz.dart';

import '../../core/core.dart';

abstract class RegisterAccountRepo {
  // Ask Admin To create account
  Future<Either<Failure, void>> registerAccount(
      {required String name, required String deviceToken});
}
