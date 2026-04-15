import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomUploadImageContainer extends StatelessWidget {
  const CustomUploadImageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      width: double.infinity,
      child: DottedBorder(
        child: Center(
          child: Column(
            spacing: 4,
            children: [
              SvgPicture.asset(
                Assets.assetsImagesUploadImage,
                colorFilter: ColorFilter.mode(
                  ColorsManger.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              Text(
                "Attach Receipt".tr(context: context),
                style: AppStylesManger.font16BoldBlack.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Tap to attach file here".tr(context: context),
                style: AppStylesManger.font14regulargray,
              ),
            ],
          ),
        ),
        options: RoundedRectDottedBorderOptions(
          radius: Radius.circular(16),
          strokeWidth: 2,
          strokeCap: StrokeCap.round,
          dashPattern: const [10, 20],
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          color: ColorsManger.borderColor,
        ),
      ),
    );
  }
}
