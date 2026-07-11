import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../controllers/customer_cubit/customer_cubit.dart';

class AddCustomerBlocListener extends StatelessWidget {
  const AddCustomerBlocListener({
    super.key,
    required this.addSuccessMessage,
    required this.editSuccessMessage,
  });

  final String addSuccessMessage;
  final String editSuccessMessage;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerCubit, CustomerState>(
      listenWhen: (state, current) =>
          current is AddCustomerSuccess ||
          current is EditCustomerSuccess ||
          current is AddCustomerError ||
          current is EditCustomerError ||
          current is AddCustomerLoading ||
          current is EditCustomerLoading,
      listener: (context, state) {
        if (state is AddCustomerSuccess) {
          context.pop();
          context.pop();

          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: addSuccessMessage,
            ),
          );
        } else if (state is EditCustomerSuccess) {
          context.pop();
          context.pop();

          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: editSuccessMessage,
            ),
          );
        } else if (state is AddCustomerError) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
            ),
          );
        } else if (state is EditCustomerError) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
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
