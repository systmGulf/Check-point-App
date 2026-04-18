import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveRequestsType extends StatelessWidget {
  const LeaveRequestsType(
      {super.key, required this.text, this.style, this.color});
  final String text;
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text, style: style),
        SizedBox(height: 8.h),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Divider(
            color: color,
            thickness: 1.9,
          ),
        ),
      ],
    );
  }
}
