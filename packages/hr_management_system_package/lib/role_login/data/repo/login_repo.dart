import 'package:dartz/dartz.dart';
import '../../../hr_manamgement_system_package.dart';

abstract class LoginRepo {
  // Role login
  Future<Either<Failure, RoleLoginModel>> roleLogin(
      RoleLoginRequestBody roleLoginRequestBody);
  // Role Employee
  Future<Either<Failure, EmployeeData>> getEmployeeById();
  // Update User Token if user delete the app and redownload
  Future<void> updateUserToken(
      {required List<String> currentUserToken, required String userId});
}
