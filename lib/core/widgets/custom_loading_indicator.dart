import 'package:flutter/material.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../utils/assets_manager.dart';
import '../styles/colors.dart';

Future<dynamic> customLoadingIndicator(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => OverlayLoaderWithAppIcon(
            isLoading: true,
            appIcon: Image.asset(
              Assets.AppLogoImage,
              height: 50,
              fit: BoxFit.contain,
            ),
            circularProgressColor: ColorsManger.primaryColor,
            child: Container(),
          ));
}
