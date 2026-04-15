import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomUploadedImageContainerItem extends StatelessWidget {
  const CustomUploadedImageContainerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsManger.borderColor),
      ),
      child: Row(
        children: [
          SvgPicture.asset(Assets.assetsImagesInvoiceContainer),
          horizontalSpace(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                "Invoice_dec_2023.png",
                style: AppStylesManger.font16BoldBlack.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "128 KB",
                style: AppStylesManger.font14regulargray.copyWith(
                  color: const Color(0xffA7A7A7),
                ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.close, color: const Color(0xffA7A7A7)),
          ),
        ],
      ),
    );
  }
}
