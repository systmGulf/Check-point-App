import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../controllers/notification_cubit/notification_cubit.dart';

class PushNotificationBlocListener extends StatelessWidget {
  const PushNotificationBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, NotificationState>(
        listenWhen: (old, current) =>
            current is NotificationSuccess ||
            current is NotificationError ||
            current is NotificationLoading,
        listener: (context, state) {
          if (state is NotificationSuccess) {
            Navigator.pop(context);
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.success(
                message: 'Notification Sent Successfully',
                // backgroundColor: Colors.red,
              ),
            );
          } else if (state is NotificationError) {
            Navigator.pop(context);
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
        child: const SizedBox.shrink());
  }
}
