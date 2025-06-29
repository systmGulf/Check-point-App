import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

buildSnackBar(BuildContext context, {required CustomSnackBar customSnackBar}) {
  return showTopSnackBar(
      animationDuration : Duration(milliseconds: 500),
      displayDuration :  Duration(milliseconds: 500),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      Overlay.of(context),
      customSnackBar);
}
