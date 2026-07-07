import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../controllers/department_cubit/department_cubit.dart';

class AddDepartmentBlocListener extends StatelessWidget {
  const AddDepartmentBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DepartmentCubit, DepartmentState>(
      listenWhen: (state, current) =>
          current is AddDepartmentSuccess ||
          current is AddDepartmentError ||
          current is AddDepartmentLoading,
      listener: (context, state) {
        if (state is AddDepartmentSuccess) {
          context.pop();
          context.pop();

          showTopSnackBar(
            Overlay.of(context),
             CustomSnackBar.success(
              message: 'Department Added Successfully'.tr(context: context),
              // backgroundColor: Colors.red,
            ),
          );
        } else if (state is AddDepartmentError) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
              // backgroundColor: Colors.red,
            ),
          );
        } else {
          customLoadingIndicator(context);
        }
      },
      child: Container(),
    );
  }
}
