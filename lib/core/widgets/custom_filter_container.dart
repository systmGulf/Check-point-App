import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/app_spaces.dart';
import '../styles/colors.dart';
import '../styles/styles.dart';

class CustomFilterContainer extends StatefulWidget {
  final String statusOne;
  final String statusTwo;
  final String statusThree;
  const CustomFilterContainer({
    super.key,
    required this.statusOne,
    required this.statusTwo,
    required this.statusThree,
  });

  @override
  State<CustomFilterContainer> createState() => _CustomFilterContainerState();
}

class _CustomFilterContainerState extends State<CustomFilterContainer> {
  bool statusOne = false;
  bool statusTwo = false;
  bool statusThree = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Text(
                    "Filter".tr(context: context),
                    style: AppStylesManger.font16BoldBlack,
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              verticalSpace(16),
              Container(
                decoration: BoxDecoration(
                  //  border: Border.all(color: ColorsManger.borderColor),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status".tr(context: context),
                            style: AppStylesManger.font16BoldBlack,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                statusOne = false;
                                statusTwo = false;
                                statusThree = false;
                              });
                              final filterData = {
                                'statusOne': false,
                                'statusTwo': false,
                                'statusThree': false,
                                'date': null,
                              };
                              Navigator.pop(context, filterData);
                            },
                            child: Text(
                              "Reset Filters".tr(context: context),
                              style: AppStylesManger.font16BoldBlack.copyWith(
                                color: ColorsManger.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(8),
                    Divider(),
                    verticalSpace(8),
                    Row(
                      children: [
                        Checkbox(
                          value: statusOne,
                          onChanged: (val) {
                            setState(() {
                              statusOne = val!;
                            });
                          },
                          activeColor: ColorsManger.primaryColor,
                        ),
                        Text(
                          widget.statusOne,
                          style: AppStylesManger.font14RegularBlack,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: statusTwo,
                          onChanged: (val) {
                            setState(() {
                              statusTwo = val!;
                            });
                          },
                          activeColor: ColorsManger.primaryColor,
                        ),
                        Text(
                          widget.statusTwo,
                          style: AppStylesManger.font14RegularBlack,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: statusThree,
                          onChanged: (val) {
                            setState(() {
                              statusThree = val!;
                            });
                          },
                          activeColor: ColorsManger.primaryColor,
                        ),
                        Text(
                          widget.statusThree,
                          style: AppStylesManger.font14RegularBlack,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              verticalSpace(16),
              Row(
                spacing: 8,
                children: [
                  Flexible(
                    child: CustomAppButton(
                      textButton: "Submit".tr(context: context),
                      buttonColor: ColorsManger.primaryColor,
                      onPressed: () {
                        final filterData = {
                          'statusOne': statusOne,
                          'statusTwo': statusTwo,
                          'statusThree': statusThree,
                        };
                        Navigator.pop(context, filterData);
                      },
                    ),
                  ),
                ],
              ),
              verticalSpace(30),
            ],
          ),
        ),
      ],
    );
  }
}
