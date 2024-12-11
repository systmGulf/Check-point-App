import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../controllers/notification_cubit/notification_cubit.dart';
import '../organism/push_notification_bloc_listener.dart';

class NotifyUsersScreen extends StatefulWidget {
  const NotifyUsersScreen({super.key});

  @override
  State<NotifyUsersScreen> createState() => _NotifyUsersScreenState();
}

class _NotifyUsersScreenState extends State<NotifyUsersScreen> {
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildCustomAppBar(context, 'Notify Users'.tr(context: context)),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomAppTextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter title'.tr(context: context);
                    }
                    return null;
                  },
                  hint: 'title'.tr(context: context),
                  controller: BlocProvider.of<NotificationCubit>(context)
                      .titleController,
                ),
                verticalSpace(20),
                CustomAppTextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter body'.tr(context: context);
                    }
                    return null;
                  },
                  hint: 'body'.tr(context: context),
                  maxLines: 5,
                  controller: BlocProvider.of<NotificationCubit>(context)
                      .bodyController,
                ),
                verticalSpace(20),
                CustomAppButton(
                    textButton: 'Send'.tr(context: context),
                    buttonColor: ColorsManger.primaryColor,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        BlocProvider.of<NotificationCubit>(context)
                            .pushNotification();
                      }
                    }),
                verticalSpace(20),
                const PushNotificationBlocListener(),
              ],
            ),
          ),
        ));
  }
}
