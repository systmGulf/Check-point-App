import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:flutter/material.dart';

class CustomReceiptDetailsAndStatusContainer extends StatelessWidget {
  final String title;
  final String amount;
  final String status;
  final String date;
  final String discription;
  const CustomReceiptDetailsAndStatusContainer({
    super.key,
    required this.title,
    required this.amount,
    required this.status,
    required this.date,
    required this.discription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                spacing: 8,
                children: [
                  Text(
                    title,
                    style: AppStylesManger.font14regulargray.copyWith(
                      color: Color(0xff767676),
                    ),
                  ),
                  Text(amount, style: AppStylesManger.font16BoldBlack),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xffFFDA6A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: AppStylesManger.font14BoldBlack.copyWith(
                    color: Color(0xff6E5100),
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(16),
          Divider(),
          verticalSpace(16),
          Text(
            "Date of Request".tr(context: context),
            style: AppStylesManger.font14regulargray.copyWith(
              color: Color(0xff767676),
            ),
          ),
          verticalSpace(8),
          Text(date, style: AppStylesManger.font16BoldBlack),
          verticalSpace(24),
          Text(
            "Description / Notes".tr(context: context),
            style: AppStylesManger.font14regulargray.copyWith(
              color: Color(0xff767676),
            ),
          ),
          verticalSpace(8),
          Text(discription, style: AppStylesManger.font16BoldBlack),
        ],
      ),
    );
  }
}
