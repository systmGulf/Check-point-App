import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../controller/leave_application/leave_application_cubit.dart';
import '../../../../../../core/styles/colors.dart';

enum LeaveRequestDateField { from, to }

class DateButtonLeaveRequest extends StatefulWidget {
  const DateButtonLeaveRequest({
    super.key,
    this.placeholder,
    this.dateField,
  });
  final String? placeholder;
  final LeaveRequestDateField? dateField;

  @override
  State<DateButtonLeaveRequest> createState() => _DateButtonLeaveRequestState();
}

class _DateButtonLeaveRequestState extends State<DateButtonLeaveRequest> {
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickDate,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 13.h),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedDate != null
                  ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                  : (widget.placeholder ??
                      DateFormat('yyyy-MM-dd').format(DateTime.now())),
              style: const TextStyle(
                color: ColorsManger.greyMedium,
                fontSize: 14,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w400,
                height: 0.10,
                letterSpacing: 0.20,
              ),
            ),
            const Spacer(),
            SizedBox(
                height: 24,
                width: 24,
                child: Center(
                    child: SvgPicture.asset('assets/images/calendar.svg'))),
          ],
        ),
      ),
    );
  }

  pickDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      final formattedDate = DateFormat('yyyy-MM-dd', 'en').format(picked);
      setState(() {
        selectedDate = picked;
        switch (widget.dateField) {
          case LeaveRequestDateField.from:
            BlocProvider.of<LeaveApplicationCubit>(context).from =
                formattedDate;
            break;
          case LeaveRequestDateField.to:
            BlocProvider.of<LeaveApplicationCubit>(context).to = formattedDate;
            break;
          case null:
            break;
        }
      });
    }
  }
}
