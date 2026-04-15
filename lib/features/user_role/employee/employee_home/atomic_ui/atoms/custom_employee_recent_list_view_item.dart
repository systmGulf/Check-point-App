import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomEmployeeRecentListViewItem extends StatelessWidget {
  final String icon;
  final String title;
  final String date;
  final String amount;
  const CustomEmployeeRecentListViewItem({
    super.key,
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: ColorsManger.borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SvgPicture.asset(icon),
          horizontalSpace(8),
          Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppStylesManger.font14BoldBlack),
              Text(date, style: AppStylesManger.font14RegularBlack),
            ],
          ),
          Spacer(),
          Text(
            amount,
            style: AppStylesManger.font14BoldBlack.copyWith(
              color: ColorsManger.redE4,
            ),
          ),
        ],
      ),
    );
  }
}
