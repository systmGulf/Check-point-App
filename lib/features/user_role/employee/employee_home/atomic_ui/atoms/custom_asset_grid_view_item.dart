import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAssetGridViewItem extends StatelessWidget {
  final String title;
  final String money;
  final String image;
  const CustomAssetGridViewItem({
    super.key,
    required this.title,
    required this.money,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: ColorsManger.borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(image),
          verticalSpace(8),
          Expanded(
            child: Text(
              title,
              style: AppStylesManger.font14RegularBlack,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          verticalSpace(4),
          Text(money, style: AppStylesManger.font14BoldBlack),
        ],
      ),
    );
  }
}
