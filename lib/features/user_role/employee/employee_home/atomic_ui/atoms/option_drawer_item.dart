import 'package:flutter/material.dart';

import '../../../../../../core/styles/styles.dart';

class OptionDrawerItem extends StatelessWidget {
  const OptionDrawerItem({
    super.key,
    required this.title,
    this.onPressed,
  });
  final String title;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: AppStylesManger.font16regulerPrimaryColor,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
