import 'package:bloc/bloc.dart';
import 'package:hr_management_system_package/core/repos/shared_model/upload_user_image_request_body.dart';
import 'package:hr_management_system_package/core/repos/shared_repo.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:meta/meta.dart';

import '../../common/image_picker_base_64.dart';

part 'upload_user_image_state.dart';

class UploadUserImageCubit extends Cubit<UploadUserImageState> {
  final SharedRepo sharedRepo;
  UploadUserImageCubit(
    this.sharedRepo,
  ) : super(UploadUserImageInitial());

  Future<void> uploadUserImage({
    required ImagePickSource source,
  }) async {
    emit(UploadUserImageLoading());
    String? image = await ImagePickerHelper.pickImageBase64(source: source);
    if (image == null)
      return emit(UploadUserImageError(message: 'No Image Selected'));
    final result = await sharedRepo.uploadUserImage(
        uploadUserImageRequestBody: UploadUserImageRequestBody(
            employeeImageUrl: image, employeeId: ApiConstant.employeeId));
    result.fold((failure) {
      emit(UploadUserImageError(message: failure.message));
    }, (r) {
      emit(UploadUserImageSuccess());
    });
  }
}
