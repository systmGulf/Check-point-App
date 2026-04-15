import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/enums/request_status.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:flutter/material.dart';

class CustomRequestContainerListViewBody extends StatelessWidget {
  final String date;
  final String moneyAmount;
  final String moneyRemaining;
  final String status;
  const CustomRequestContainerListViewBody({
    super.key,
    required this.date,
    required this.moneyAmount,
    required this.moneyRemaining,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Date of Request".tr(context: context),
                    style: AppStylesManger.font14regulargray.copyWith(
                      color: Color(0xff767676),
                    ),
                  ),
                  verticalSpace(8),
                  Text(date, style: AppStylesManger.font16BoldBlack),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: RequestStatus.Approved.name == status
                      ? ColorsManger.doneColor
                      : RequestStatus.Rejected.name == status
                          ? ColorsManger.redE4.withValues(alpha: 0.1)
                          : Color(0xffFFDA6A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: AppStylesManger.font14BoldBlack.copyWith(
                    color: RequestStatus.Approved.name == status
                        ? ColorsManger.primaryColorLight
                        : RequestStatus.Rejected.name == status
                            ? ColorsManger.redE4
                            : Color(0xff6E5100),
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(18),
          Divider(),
          verticalSpace(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Money Amount".tr(context: context),
                    style: AppStylesManger.font14regulargray.copyWith(
                      color: Color(0xff767676),
                    ),
                  ),
                  verticalSpace(8),
                  Text(moneyAmount, style: AppStylesManger.font16BoldBlack),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Remaining".tr(context: context),
                    style: AppStylesManger.font14regulargray.copyWith(
                      color: Color(0xff767676),
                    ),
                  ),
                  verticalSpace(8),
                  Text(moneyRemaining, style: AppStylesManger.font16BoldBlack),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
