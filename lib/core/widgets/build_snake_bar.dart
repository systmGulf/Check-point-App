import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

buildSnackBar(BuildContext context,
    { required CustomSnackBar customSnackBar}) {
  return showTopSnackBar(Overlay.of(context), customSnackBar);
}
