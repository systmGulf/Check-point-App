import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/pages/employee_preview.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    super.key,
    this.date,
    this.area,
    this.clockInTime,
    this.clockOutTime,
    this.totalhours,
    this.isEarly,
    this.isLate,
  });
  final String? date, area, clockInTime, clockOutTime, totalhours;
  final bool? isEarly, isLate;
  @override
  Widget build(BuildContext context) {
    DateTime clockIn =
        DateTime.parse('2000-01-01 ${clockInTime?.substring(0, 5)}:00');
    DateTime clockOut =
        DateTime.parse('2000-01-01 ${clockOutTime?.substring(0, 5)}:00');

    return Container(
        child: Container(
            // decoration: AppConatinerDecoration(),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date ?? "",
                        style: AppStylesManger.font15BoldrBlue
                            .copyWith(color: Colors.grey),
                      ),
                      Text(
                        area?.tr(
                              context: context,
                            ) ??
                            "",
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
                            clockInTime ?? "",
                            // convertTo12HourFormat(
                            //   clockInTime?.substring(0, 5) ?? "",
                            // ),
                            style: TextStyle(
                              color: isLate ?? false
                                  ? Colors.red
                                  : ColorsManger.primaryColor,
                              fontWeight: (isLate ?? false)
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
                            'Clock Out'.tr(
                              context: context,
                            ),
                            style: AppStylesManger.font15BoldrBlue
                                .copyWith(color: Colors.grey),
                          ),
                          clockOutTime == '00:00:00'
                              ? Text('--')
                              : Text(
                                  clockOutTime ?? "",
                                  // convertTo12HourFormat(
                                  //   clockOutTime?.substring(0, 5) ?? "",
                                  // ),
                                  style: TextStyle(
                                    color: isEarly ?? false
                                        ? Colors.red
                                        : ColorsManger.primaryColor,
                                    fontWeight: isEarly ?? false
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
                                  formatTotalHoursWorked(
                                      double.parse(totalhours ?? "")),
                                  style: TextStyle(
                                    color: isEarly ?? false
                                        ? Colors.red
                                        : ColorsManger.primaryColor,
                                    fontWeight: isEarly ?? false
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
