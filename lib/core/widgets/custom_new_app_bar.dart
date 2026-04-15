import 'package:employee_mangement/core/styles/styles.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget customNewAppBar({
  required String title,
  List<Widget>? actions,
  bool? centerTitle,
  Widget? leading,
}) {
  return AppBar(
    title: Text(title, style: AppStylesManger.font18BoldBlack),
    centerTitle: centerTitle ?? true,
    backgroundColor: Colors.white,
    elevation: 2,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    actions: actions,
    leading: leading,
  );
}
