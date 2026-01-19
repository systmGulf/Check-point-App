import 'package:flutter/material.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';

class ActiveDrawerItem extends StatelessWidget {
  const ActiveDrawerItem({super.key, required this.text, required this.icon});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.indigo),
              horizontalSpace(8),
              Text(
                text,
                style: AppStylesManger.font15regulerGrey
                    .copyWith(color: Colors.black),
              ),
            ],
          ),
          verticalSpace(6),
        ],
      ),
    );
  }
}
