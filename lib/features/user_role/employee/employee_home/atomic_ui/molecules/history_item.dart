import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/common/convert_time_to_12_houre_format.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    super.key,
    required this.date,
    required this.area,
    required this.clockInTime,
    required this.clockOutTime,
    required this.totalhours,
  });
  final String date, area, clockInTime, clockOutTime, totalhours;
  @override
  Widget build(BuildContext context) {
    DateTime clockIn =
        DateTime.parse('2000-01-01 ${clockInTime.substring(0, 5)}:00');
    DateTime clockOut =
        DateTime.parse('2000-01-01 ${clockOutTime.substring(0, 5)}:00');

    DateTime lateCheckInThreshold = DateTime.parse('2000-01-01 10:00:00');
    DateTime earlyCheckOutThreshold = DateTime.parse('2000-01-01 17:00:00');

    bool isLate = clockIn.isAfter(lateCheckInThreshold);
    bool isEarly = clockOut.isBefore(earlyCheckOutThreshold);

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
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: AppStylesManger.font15BoldrBlue
                            .copyWith(color: Colors.grey),
                      ),
                      Text(
                        area.tr(
                          context: context,
                        ),
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
                          Text(
                            convertTo12HourFormat(
                              clockInTime.substring(0, 5),
                            ),
                            style: TextStyle(
                              color: isLate
                                  ? Colors.red
                                  : ColorsManger.primaryColor,
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
                          clockOutTime == '00:00:00'
                              ? Text('--')
                              : Text(
                                  convertTo12HourFormat(
                                    clockOutTime.substring(0, 5),
                                  ),
                                  style: TextStyle(
                                    color: isEarly
                                        ? Colors.red
                                        : ColorsManger.primaryColor,
                                    fontWeight: isEarly
                                        ? FontWeight.bold
                                        : FontWeight.normal,
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
                          clockOutTime == '00:00:00'
                              ? Text('--')
                              : Text(
                                  totalhours.substring(0, 3),
                                  style: TextStyle(
                                    color: isEarly
                                        ? Colors.red
                                        : ColorsManger.primaryColor,
                                    fontWeight: isEarly
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                ),
                        ],
                      )
                    ],
                  ),
                  horizontalSpace(10),
                ])));
  }
}
