import 'package:employee_mangement/core/cubits/upload_user_image_cubit/upload_user_image_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/widgets/custom_loading_indicator.dart';

class PickImageBlocListener extends StatelessWidget {
  const PickImageBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadUserImageCubit, UploadUserImageState>(
      listenWhen: (previous, current) =>
          current is UploadUserImageSuccess ||
          current is UploadUserImageError ||
          current is UploadUserImageLoading,
      listener: (context, state) {
        if (state is UploadUserImageSuccess) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: 'Image Updated successfully',
            ),
          );
        } else if (state is UploadUserImageError) {
          Overlay.of(context);
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.message,
            ),
          );
        } else {
          customLoadingIndicator(context);
        }
      },
      child: SizedBox.shrink(),
    );
  }
}
