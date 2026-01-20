import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomFilterFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const CustomFilterFloatingActionButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: ColorsManger.lightblack.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(-2, 0),
            ),
          ],
          color: Colors.white,
          border:
              Border.all(color: ColorsManger.lightblack.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: GestureDetector(
          onTap: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              SvgPicture.asset(Assets.FilterButtonImage),
              Text(
                "Filter".tr(context: context),
                style: AppStylesManger.font14Medium,
              )
            ],
          ),
        ));
  }
}
