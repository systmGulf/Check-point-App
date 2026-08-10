import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/core/repos/shared_model/upload_user_image_request_body.dart';
import 'package:hr_management_system_package/core/repos/shared_repo.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../common/image_picker_base_64.dart';

part 'upload_user_image_state.dart';

class UploadUserImageCubit extends Cubit<UploadUserImageState> {
  UploadUserImageCubit({required this.sharedRepo})
      : super(UploadUserImageInitial());

  final SharedRepo sharedRepo;

  Future<void> uploadUserImage({
    required ImagePickSource source,
  }) async {
    emit(UploadUserImageLoading());
    final image = await ImagePickerHelper.pickImageBase64(source: source);
    if (image == null) {
      if (!isClosed) {
        emit(UploadUserImageError(message: 'error.no_image_selected'));
      }
      return;
    }
    final result = await sharedRepo.uploadUserImage(
      uploadUserImageRequestBody: UploadUserImageRequestBody(
        employeeImageUrl: image,
        employeeId: ApiConstant.employeeId,
      ),
    );
    result.fold(
      (failure) {
        if (!isClosed) emit(UploadUserImageError(message: failure.message));
      },
      (r) {
        if (!isClosed) emit(UploadUserImageSuccess());
      },
    );
  }
}
