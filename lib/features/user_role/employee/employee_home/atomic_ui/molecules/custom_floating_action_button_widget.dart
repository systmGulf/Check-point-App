import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';

class CustomFloatingActionButtonWidget extends StatelessWidget {
  const CustomFloatingActionButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    final currentLanguageCode = currentLocale.languageCode;

    return SpeedDial(
      backgroundColor: ColorsManger.primaryColor,
      icon: Icons.add,
      iconTheme: const IconThemeData(size: 30, color: Colors.white),
      activeIcon: Icons.close,
      activeForegroundColor: Colors.white,
      activeBackgroundColor: ColorsManger.primaryColor,
      spacing: 3,
      switchLabelPosition: currentLanguageCode == 'en' ? false : true,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.radio_button_checked_outlined),
          backgroundColor: ColorsManger.primaryColor,
          foregroundColor: Colors.white,
          label: 'Claim Application'.tr(context: context),
          onTap: () {
            context.pushName(Routes.requestClaimApplicationScreen);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.accessibility),
          backgroundColor: ColorsManger.primaryColor,
          foregroundColor: Colors.white,
          label: 'Leave Application'.tr(context: context),
          onTap: () {
            context.pushName(Routes.leaveApplicationScreen);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.local_hospital_outlined),
          backgroundColor: ColorsManger.primaryColor,
          foregroundColor: Colors.white,
          label: 'accident Myself'.tr(context: context),
          onTap: () {
            context.pushName(Routes.incidentMyself);
          },
        ),
      ],
    );
  }
}
