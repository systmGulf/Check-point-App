import 'package:dartz/dartz.dart';
import 'package:hr_management_system_package/core/repos/shared_model/upload_user_image_request_body.dart';
import 'package:hr_management_system_package/core/repos/shared_repo.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

class SharedRepoImpl  implements SharedRepo{
  final ApiService apiService;
  SharedRepoImpl({required this.apiService});
  @override
  Future<Either<Failure, String>> uploadUserImage({required UploadUserImageRequestBody uploadUserImageRequestBody})async {
    try {
      final result = await apiService.put(endPoint: "Employee/${ApiConstant.uploadUserImage}", body: uploadUserImageRequestBody.toJson());
      if (result['isSuccess'] == true) {
        return Right( "Image uploaded successfully");
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}