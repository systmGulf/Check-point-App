import 'package:dartz/dartz.dart';
import 'package:hr_management_system_package/core/repos/shared_model/upload_user_image_request_body.dart';

import '../errors/error_handler.dart';

abstract class SharedRepo {
  Future<Either<Failure, String>> uploadUserImage({required UploadUserImageRequestBody uploadUserImageRequestBody});
}