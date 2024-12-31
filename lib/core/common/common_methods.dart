import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../helpers/extention.dart';
import '../routing/routes.dart';

class CommonMethods {
  checkConnectivity(BuildContext context) async {
    List<ConnectivityResult> conmnectivityReult =
        await Connectivity().checkConnectivity();
    if (conmnectivityReult.contains(ConnectivityResult.mobile) ||
        conmnectivityReult.contains(ConnectivityResult.wifi)) {
      Future.delayed(const Duration(seconds: 4), () {
        if (context.mounted) {
          context.pushReplacementName(Routes.onboardingscreen);
        }
      });
    } else {
      if (context.mounted) {
        Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.error(
                message: "Please check your internet connection and try again",
              ),
            );
          }
        });
      }
      return false;
    }
  }
}
