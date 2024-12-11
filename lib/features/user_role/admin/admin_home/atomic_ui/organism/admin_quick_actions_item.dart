import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';

class QuickActionsItem extends StatelessWidget {
  const QuickActionsItem({
    super.key,
    required this.icon,
    required this.text,
    required this.action,
  });
  final IconData icon;
  final String text;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        horizontalSpace(10),
        Text(
          text,
          style: AppStylesManger.font14RegularBlack,
        ),
        const Spacer(),
        Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
            ),
            child: TextButton(
              style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
              onPressed: action,
              child: Text('Add'.tr(context: context),
                  style: AppStylesManger.font13DarkBlueMedium),
            )),
        horizontalSpace(10),
      ],
    );
  }
}
