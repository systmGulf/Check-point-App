import 'package:client_information/client_information.dart';
import 'package:dartz/dartz.dart';
// import 'package:device_info_plus/device_info_plus.dart';

import '../../hr_manamgement_system_package.dart';
import '../models/register_account_request_body.dart';
import 'register_account_repo.dart'; // Adjust the import path

class RegisterAccountRepoImpl implements RegisterAccountRepo {
  final ApiService apiService;

  RegisterAccountRepoImpl({required this.apiService});

  @override
  // Admin add new user
  Future<Either<Failure, void>> registerAccount(
      {required String name, required String deviceToken}) async {
    try {
      String? deviceId = await getId();
      if (deviceId != null) {
        final result = await apiService.post(
            endPoint: ApiConstant.accountRequest,
            body: RegisterAccountRequestBody(
              name: name,
              mobileId: deviceId,
              deviceToken: deviceToken,
            ).toJson());
        if (result[ApiConstant.successApiKey] == true) {
          return const Right(null);
        } else {
          return Left(ErrorHandler.responseFailure(result));
        }
      } else {
        return Left(ErrorHandler.unexpectedFailure(
          message: 'Device token not found',
          code: ResponseCode.badRequest,
        ));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}

// Get Device Id this Id is Unit for any device
Future<String?> getId() async {
  return (await ClientInformation.fetch()).deviceId;
  // var deviceInfo = DeviceInfoPlugin();
  // if (Platform.isIOS) {
  //   var iosDeviceInfo = await deviceInfo.iosInfo;
  //   return iosDeviceInfo.identifierForVendor;
  // } else if (Platform.isAndroid) {
  //   var androidDeviceInfo = await deviceInfo.androidInfo;
  //   return androidDeviceInfo.id;
  // }
  // return null;
}
