import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeAndDateWidet extends StatelessWidget {
  const TimeAndDateWidet({super.key});

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat(
        tr('date_format', context: context), context.locale.toString());
    DateFormat timeFormat = DateFormat(
        tr('time_format', context: context), context.locale.toString());

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              return Text(
                timeFormat.format(DateTime.now()),
                style: TextStyle(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              );
            },
          ),
          Text(
            dateFormat.format(DateTime.now()),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}
