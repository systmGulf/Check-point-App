import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class DateButtonLeaveRequest extends StatefulWidget {
  const DateButtonLeaveRequest({
    super.key,
    this.text,
    this.onDateSelected,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });
  final String? text;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<DateButtonLeaveRequest> createState() => _DateButtonLeaveRequestState();
}

class _DateButtonLeaveRequestState extends State<DateButtonLeaveRequest> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  void didUpdateWidget(covariant DateButtonLeaveRequest oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      selectedDate = widget.initialDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = selectedDate == null
        ? (widget.text ?? 'Select Date')
        : DateFormat('dd MMM yyyy').format(selectedDate!);

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
              displayText,
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
            SizedBox(
                height: 24,
                width: 24,
                child: Center(
                    child: SvgPicture.asset('assets/images/calendar.svg')))
          ],
        ),
      ),
    );
  }

  pickDate() async {
    final now = DateTime.now();
    final initial = selectedDate ?? widget.initialDate ?? now;
    final first = widget.firstDate ?? now;
    final last = widget.lastDate ?? DateTime(2101);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(first) ? first : initial,
      firstDate: first,
      lastDate: last,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      widget.onDateSelected?.call(picked);
    }
  }
}
