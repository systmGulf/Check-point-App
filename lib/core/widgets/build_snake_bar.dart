import 'package:flutter/material.dart';

import 'app_top_snack_bar.dart';

void buildSnackBar(
  BuildContext context, {
  required CustomSnackBar customSnackBar,
}) {
  showTopSnackBar(
    Overlay.of(context),
    customSnackBar,
    displayDuration: customSnackBar.duration,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  );
}
