import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/styles/styles.dart';
import 'package:flutter/material.dart';

class SupervisorNotificationsScreen extends StatelessWidget {
  const SupervisorNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.notifications_active_rounded,
            color: Colors.grey,
            size: 100,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "You Don't have any Notification Yet".tr(context: context),
              style: AppStylesManger.font20semiBoldBlack,
            ),
          ),
          Text(
            'we will send you notification soon .'.tr(context: context),
          )
        ],
      ),
    );
  }
}
