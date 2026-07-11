import 'package:flutter/material.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../utils/assets_manager.dart';
import '../styles/colors.dart';

Future<dynamic> customLoadingIndicator(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => OverlayLoaderWithAppIcon(
            isLoading: true,
            appIcon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorsManger.primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColorsManger.primaryColor.withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Image.asset(
                Assets.AppLogoImage,
                height: 30,
                width: 30,
                fit: BoxFit.contain,
              ),
            ),
            circularProgressColor: ColorsManger.primaryColor,
            child: Container(),
          ));
}
