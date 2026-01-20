import 'package:employee_mangement/core/common/image_picker_base_64.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/widgets/pick_image_from_gallary_or_camera_widget.dart';
import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/core/networking/api_constant.dart';

import '../contoller/roles_login_cubit/login_cubit.dart';
import '../cubits/upload_user_image_cubit/upload_user_image_cubit.dart';

class UserImageAndPickingImageButton extends StatelessWidget {
  const UserImageAndPickingImageButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        UserImage(
          imageUrl: ApiConstant.imageUrl,
          height: 80.h,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: GestureDetector(
            onTap: () async {
              selectImageDialog(
                  context: context,
                  SelectedGalleryAction: () async {
                    await context
                        .read<UploadUserImageCubit>()
                        .uploadUserImage(source: ImagePickSource.gallery)
                        .then((value) async {
                      await context.read<LoginCubit>().getEmployeeById();
                    }).then((value) {
                      context.pop();
                    });
                  },
                  SelectedCameraAction: () async {
                    await context
                        .read<UploadUserImageCubit>()
                        .uploadUserImage(source: ImagePickSource.camera)
                        .then((value) async {
                      await context.read<LoginCubit>().getEmployeeById();
                    }).then((value) {
                      context.pop();
                    });
                  });
            },
            child: CircleAvatar(
              radius: 12.r,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
