import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:flutter/material.dart';

import '../helpers/app_spaces.dart';
import '../styles/styles.dart';

class FeedBackInPlanWidget extends StatelessWidget {
  const FeedBackInPlanWidget(
      {super.key,
      required this.feedBack,
      required this.status,
      required this.imageUrl});
  final String feedBack, status, imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: UserImage(
                    height: 50,
                    imageUrl: imageUrl,
                  )),
              horizontalSpace(12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Visit status".tr(),
                            style: AppStylesManger.font14RegularBlack.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            status.tr(),
                            style: AppStylesManger.font14RegularBlack.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(8),
                      Text(
                        feedBack.tr(),
                        style: AppStylesManger.font14RegularBlack.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      verticalSpace(8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
