import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TodoFlagAndDateItem extends StatelessWidget {
  const TodoFlagAndDateItem({
    super.key,
    required this.priority,
    required this.date,
  });
  final String priority, date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.flag_outlined,
          color: priority == 'Low'.tr(context: context)
              ? const Color(0xFF0087FF)
              : priority == 'Medium'.tr(context: context)
                  ? const Color(0xFF5F33E1)
                  : const Color(0xFFE73C3C),
        ),
        Text(
          priority,
          style: TextStyle(
            color: priority == 'Low'.tr(context: context)
                ? const Color(0xFF0087FF)
                : priority == 'Medium'.tr(context: context)
                    ? const Color(0xFF5F33E1)
                    : const Color(0xFFE73C3C),
            fontSize: 12,
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w500,
            height: 0.12,
          ),
        ),
        Spacer(),
        Text(
          date.substring(0, 10),
          style: const TextStyle(
            color: Color(0x9924252C),
            fontSize: 12,
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w400,
            height: 0.12,
          ),
        ),
      ],
    );
  }
}
