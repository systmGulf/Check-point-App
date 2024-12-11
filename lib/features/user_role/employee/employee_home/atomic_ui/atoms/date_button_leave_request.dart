import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../controller/leave_application/leave_application_cubit.dart';

class DateButtonLeaveRequest extends StatefulWidget {
  const DateButtonLeaveRequest({
    super.key,
    this.text,
  });
  final String? text;

  @override
  State<DateButtonLeaveRequest> createState() => _DateButtonLeaveRequestState();
}

class _DateButtonLeaveRequestState extends State<DateButtonLeaveRequest> {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 13.h),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.text ??
                '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
            style: const TextStyle(
              color: Color(0xFF7F7F7F),
              fontSize: 14,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w400,
              height: 0.10,
              letterSpacing: 0.20,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              pickDate();
            },
            child: SizedBox(
                height: 24,
                width: 24,
                child: Center(
                    child: SvgPicture.asset('assets/images/calendar.svg'))),
          )
        ],
      ),
    );
  }

  pickDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        DateFormat('yyyy-MM-dd').format(selectedDate);
        if (widget.text == 'From' || widget.text == 'من') {
          BlocProvider.of<LeaveApplicationCubit>(context).from =
              selectedDate.toString().substring(0, 10);
        } else {
          BlocProvider.of<LeaveApplicationCubit>(context).to =
              selectedDate.toString().substring(0, 10);
        }
      });
    }
  }
}
