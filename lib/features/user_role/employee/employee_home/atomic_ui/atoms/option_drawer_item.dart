import 'package:flutter/material.dart';

import '../../../../../../core/styles/colors.dart';
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
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 12,
        end: 8,
        bottom: 8,
      ),
      child: Material(
        color: const Color(0xffFFF5F5),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppStylesManger.font14BoldBlack.copyWith(
                      color: ColorsManger.primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: ColorsManger.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
