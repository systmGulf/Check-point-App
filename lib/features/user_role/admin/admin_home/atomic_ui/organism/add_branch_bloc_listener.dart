import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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
          BlocProvider.of<BranchCubit>(context).getBranches();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: 'Branch Added Successfully'.tr(context: context),
              // backgroundColor: Colors.red,
            ),
          );
        } else if (state is AddBranchError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        } else {
          showDialog(
              context: context,
              builder: (context) => OverlayLoaderWithAppIcon(
                    isLoading: true,
                    appIcon: Image.asset(
                      'assets/images/logo-w.png',
                      height: 50,
                      color: Colors.orange,
                    ),
                    circularProgressColor: Colors.orange,
                    child: Container(),
                  ));
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
