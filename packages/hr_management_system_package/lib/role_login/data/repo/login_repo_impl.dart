import 'package:dartz/dartz.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../hr_manamgement_system_package.dart';

class LoginRepoImpl implements LoginRepo {
  final ApiService apiservice;

  LoginRepoImpl({required this.apiservice});

  @override
  Future<Either<Failure, RoleLoginModel>> roleLogin(
      RoleLoginRequestBody roleLoginRequestBody) async {
    // Listen to the connectivity status using isConnected.value
    try {
      final response = await apiservice.post(
        endPoint: ApiConstant.login,
        body: roleLoginRequestBody.toJson(),
      );

      if (response[ApiConstant.successApiKey] == true) {
        List<dynamic> roles = response['value']['roles'] ?? [];
        if (roles.contains(roleLoginRequestBody.role)) {
          await SecureCache.insertToCache(
            key: 'token',
            value: response['value']['token'],
          );
          await SecureCache.insertToCache(
            key: 'username',
            value: response['value']['userName'],
          );
          await SecureCache.insertToCache(
            key: 'employeeId',
            value: response['value']['id'],
          );

          ApiConstant.token = await SecureCache.getFromCache(key: 'token');
          ApiConstant.username =
              await SecureCache.getFromCache(key: 'username');
          ApiConstant.employeeId =
              await SecureCache.getFromCache(key: 'employeeId');
          return Right(RoleLoginModel.fromJson(response));
        } else {
          return Left(ErrorHandler.unexpectedFailure(
            message: "Make sure you are an ${roleLoginRequestBody.role}",
            code: ResponseCode.badRequest,
          ));
        }
      } else {
        return Left(ErrorHandler.responseFailure(response));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, EmployeeData>> getEmployeeById() async {
    // Listen to the connectivity status using isConnected.value
    try {
      final result = await apiservice.get(
          endPoint: "${ApiConstant.employee}/${ApiConstant.employeeId}");

      if (result[ApiConstant.successApiKey] == true) {
        await SecureCache.insertToCache(
          key: 'departmentId',
          value: result['value']['departmentId'].toString(),
        );
        await SecureCache.insertToCache(
          key: 'position',
          value: result['value']['position'].toString(),
        );
        await SecureCache.insertToCache(
          key: 'employeeId',
          value: result['value']['id'].toString(),
        );
        await SecureCache.insertToCache(
          key: 'employeeCheckinTime',
          value: result['value']['clockInTime'].toString(),
        );
        await SecureCache.insertToCache(
          key: 'employeeCheckoutTime',
          value: result['value']['clockOutTime'].toString(),
        );
        await SecureCache.insertToCache(
          key: 'imageUrl',
          value: result['value']['imageUrl'].toString(),
        );
        await SecureCache.insertToCache(
          key: 'shiftName',
          value: result['value']['shiftName'].toString(),
        );
        ApiConstant.employeeCheckinTime =
            await SecureCache.getFromCache(key: 'employeeCheckinTime');
        ApiConstant.employeeCheckoutTime =
            await SecureCache.getFromCache(key: 'employeeCheckoutTime');
        ApiConstant.imageUrl = await SecureCache.getFromCache(key: 'imageUrl');
        ApiConstant.shiftName =
            await SecureCache.getFromCache(key: 'shiftName');
        ApiConstant.employeeId =
            await SecureCache.getFromCache(key: 'employeeId');
        final userTokens = result['value']['deviceTokens'] as List<dynamic>;
        final currentToken = await SecureCache.getFromCache(key: 'deviceToken');
        if (currentToken.isNotEmpty && !userTokens.contains(currentToken)) {
          await updateUserToken(
            userId: ApiConstant.employeeId,
            currentUserToken: [currentToken],
          );
        }

        ApiConstant.departmentId =
            await SecureCache.getFromCache(key: 'departmentId');

        ApiConstant.position = await SecureCache.getFromCache(key: 'position');

        await SecureCache.insertToCache(
          key: 'branchId',
          value: result['value']['branchId'].toString(),
        );
        ApiConstant.branchId = await SecureCache.getFromCache(key: 'branchId');
        if (ApiConstant.departmentId != '') {
          return Right(EmployeeData.fromJson(result['value']));
        } else {
          return Left(ErrorHandler.unexpectedFailure(
            message: 'No data found',
            code: ResponseCode.notFound,
          ));
        }
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<void> updateUserToken(
      {required List<String> currentUserToken, required String userId}) async {
    try {
      final requestBody = UpdateUserTokenRequestBody(
        userId: userId,
        deviceTokens: currentUserToken,
      );
      await apiservice.put(
        endPoint: ApiConstant.updateUserToken,
        body: requestBody.toJson(),
      );
    } on Object catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }
}
