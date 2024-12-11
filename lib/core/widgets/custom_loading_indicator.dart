import 'package:flutter/material.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

Future<dynamic> customLoadingIndicator(BuildContext context) {
  return showDialog(
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
