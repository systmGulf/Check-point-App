import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/custom_loading_indicator.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/branch_cubit/branch_cubit.dart';

class AddBranchBlocListener extends StatelessWidget {
  const AddBranchBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BranchCubit, BranchState>(
      listenWhen: (previous, current) =>
          current is AddBranchSuccess ||
          current is AddBranchError ||
          current is AddBranchLoading,
      listener: (context, state) {
        if (state is AddBranchSuccess) {
          Navigator.pop(context);
          Navigator.pop(context);

          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: 'Branch Added Successfully'.tr(context: context),
              // backgroundColor: Colors.red,
            ),
          );
        } else if (state is AddBranchError) {
          AppTopSnackBar.showFailure(context, message: state.error);
        } else {
          customLoadingIndicator(context);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
