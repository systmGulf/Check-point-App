import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/common/convert_time_to_12_houre_format.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class EmployeeAttendance extends StatelessWidget {
  const EmployeeAttendance({
    super.key,
    required this.employeeName,
    required this.location,
    required this.inTime,
    required this.outTime,
    required this.id,
    required this.totalHours,
    this.employeeImage,
  });

  final String employeeName, location, inTime, outTime, id;
  final String totalHours;
  final String? employeeImage;

  @override
  Widget build(BuildContext context) {
    DateTime inDateTime =
        DateTime.parse('2000-01-01 ${inTime.substring(0, 5)}:00');
    DateTime outDateTime =
        DateTime.parse('2000-01-01 ${outTime.substring(0, 5)}:00');

    DateTime lateCheckInThreshold = DateTime.parse('2000-01-01 10:00:00');
    DateTime earlyCheckOutThreshold = DateTime.parse('2000-01-01 17:00:00');

    bool isLate = inDateTime.isAfter(lateCheckInThreshold);
    bool isEarly = outDateTime.isBefore(earlyCheckOutThreshold);

    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: ColorsManger.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                  image:
                      const AssetImage('assets/images/icon-default-user.png'),
                  height: 30.h),
              horizontalSpace(10),
              Text(
                employeeName,
                style: AppStylesManger.font15BoldrBlue
                    .copyWith(color: Colors.black),
              ),
              employeeImage != null
                  ? SizedBox(
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: SizedBox(
                                    height:
                                        MediaQuery.sizeOf(context).height * 0.5,
                                    width: 300.w,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Employee Image",
                                          style: AppStylesManger.font15BoldrBlue
                                              .copyWith(color: Colors.black),
                                        ),
                                        verticalSpace(5),
                                        CachedNetworkImage(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.46,
                                          fit: BoxFit.fill,
                                          imageUrl:
                                              "http://ems.runasp.net${employeeImage!}",
                                          placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(
                                            color: ColorsManger.primaryColor,
                                            valueColor: AlwaysStoppedAnimation(
                                              ColorsManger.primaryColor,
                                            ),
                                          )),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        icon: Icon(
                          Icons.camera,
                          color: ColorsManger.primaryColor,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location,
                style: AppStylesManger.font15BoldrBlue
                    .copyWith(color: Colors.black),
              ),
              Text(
                'Present'.tr(
                  context: context,
                ),
                style: AppStylesManger.font15BoldrBlue
                    .copyWith(color: Colors.green),
              ),
            ],
          ),
          verticalSpace(12),
          const DottedLine(),
          verticalSpace(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Clock In'.tr(
                      context: context,
                    ),
                    style: AppStylesManger.font15BoldrBlue
                        .copyWith(color: Colors.grey),
                  ),
                  inTime == '00:00:00'
                      ? const Icon(CupertinoIcons.clock, color: Colors.grey)
                      : Text(
                          convertTo12HourFormat(
                            inTime.substring(0, 5),
                          ),
                          style: TextStyle(
                            color: isLate ? Colors.red : Colors.green,
                            fontWeight:
                                isLate ? FontWeight.bold : FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Clock Out'.tr(
                      context: context,
                    ),
                    style: AppStylesManger.font15BoldrBlue
                        .copyWith(color: Colors.grey),
                  ),
                  outTime == '00:00:00'
                      ? const Icon(CupertinoIcons.clock, color: Colors.grey)
                      : Text(
                          convertTo12HourFormat(
                            outTime.substring(0, 5),
                          ),
                          style: TextStyle(
                            color: isEarly ? Colors.red : Colors.green,
                            fontWeight:
                                isEarly ? FontWeight.bold : FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Total hr'.tr(
                      context: context,
                    ),
                    style: AppStylesManger.font15BoldrBlue
                        .copyWith(color: Colors.grey),
                  ),
                  inTime == '00:00:00' || outTime == '00:00:00'
                      ? const Icon(CupertinoIcons.clock, color: Colors.grey)
                      : Text(
                          totalHours.substring(0, 3),
                          style: TextStyle(
                            color: isEarly
                                ? Colors.red
                                : ColorsManger.primaryColor,
                            fontWeight:
                                isEarly ? FontWeight.bold : FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                ],
              )
            ],
          ),
          horizontalSpace(10),
        ]),
      ),
    );
  }
}
