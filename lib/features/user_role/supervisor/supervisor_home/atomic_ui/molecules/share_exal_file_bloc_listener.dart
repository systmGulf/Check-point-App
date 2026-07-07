import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../../../../../core/widgets/app_top_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../contoller/share_attendace_cubit/shareattendance_cubit.dart';

class ShareExalFileBlocListener extends StatelessWidget {
  const ShareExalFileBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShareattendanceCubit, ShareattendanceState>(
      listenWhen: (previous, current) =>
          current is ShareAttAndanceSuccess ||
          current is ShareAttAndanceFailure ||
          current is ShareAttAndanceLoading,
      listener: (context, state) {
        if (state is ShareAttAndanceSuccess) {
          Navigator.pop(context);
        } else if (state is ShareAttAndanceFailure) {
          Navigator.pop(context);
          AppTopSnackBar.showFailure(context, message: state.er);
        } else {
          customLoadingIndicator(context);
        }
      },
      child: Container(),
    );
  }
}
