import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/helpers/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../controllers/customer_cubit/customer_cubit.dart';

class AddCustomerBlocListener extends StatelessWidget {
  const AddCustomerBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerCubit, CustomerState>(
      listenWhen: (state, current) =>
          current is AddCustomerSuccess ||
          current is AddCustomerError ||
          current is AddCustomerLoading,
      listener: (context, state) {
        if (state is AddCustomerSuccess) {
          context.pop();
          context.pop();

          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: 'Customer Added Successfully'.tr(context: context),
              // backgroundColor: Colors.red,
            ),
          );
        } else if (state is AddCustomerError) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
              // backgroundColor: Colors.red,
            ),
          );
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
      child: Container(),
    );
  }
}
