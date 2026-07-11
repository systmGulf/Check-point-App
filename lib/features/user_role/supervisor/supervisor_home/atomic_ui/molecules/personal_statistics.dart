import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class PersonalStatistics extends StatefulWidget {
  const PersonalStatistics(
      {super.key,
      required this.late,
      required this.absent,
      required this.present});
  final double late, absent, present;

  @override
  State<PersonalStatistics> createState() => _PersonalStatisticsState();
}

class _PersonalStatisticsState extends State<PersonalStatistics> {
  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Late".tr(): widget.late / 100,
      "Absent".tr(): widget.absent / 100,
      "Present".tr(): widget.present / 100,
    };
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 900),
        chartLegendSpacing: MediaQuery.of(context).size.width / 3,
        chartRadius: MediaQuery.of(context).size.width / 2,
        colorList: [
          ColorsManger.primaryColor,
          Colors.blueAccent,
          ColorsManger.lighorage
        ],
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 15,
        centerText: "Personal Statistics".tr(),
        centerTextStyle: AppStylesManger.font6BoldBlack,
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: false,
          showChartValues: false,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
      ),
    );
  }
}
