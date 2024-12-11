import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../controllers/department_cubit/department_cubit.dart';

class EditDepartmentBlocListener extends StatelessWidget {
  const EditDepartmentBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DepartmentCubit, DepartmentState>(
      listenWhen: (previous, current) =>
          current is EditDepartmentSuccess ||
          current is EditDepartmentError ||
          current is EditDepartmentLoading,
      listener: (context, state) {
        if (state is EditDepartmentSuccess) {
          context.pop();
          context.pop();

          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: 'Department Edited Successfully'.tr(context: context),
            ),
          );
        }
        if (state is EditDepartmentError) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
            ),
          );
        } else if (state is EditDepartmentLoading) {
          customLoadingIndicator(context);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
