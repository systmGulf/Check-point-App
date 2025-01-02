import 'package:flutter/material.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../styles/colors.dart';

Future<dynamic> customLoadingIndicator(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => OverlayLoaderWithAppIcon(
            isLoading: true,
            appIcon: Image.asset(
              'assets/images/app_logo.png',
              height: 50,
              color: ColorsManger.primaryColor,
            ),
            circularProgressColor: ColorsManger.primaryColor,
          child: Container(),
          ));
}
