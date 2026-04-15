import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';



class CustomInvoiceImageContainer extends StatelessWidget {
  const CustomInvoiceImageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            "Receipts & Invoices".tr(context: context),
            style: AppStylesManger.font16BoldBlack,
          ),
          verticalSpace(16),
          Image.asset(
            Assets.assetsImagesInvoiceImage,
            width: double.maxFinite,
            height: 150,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
