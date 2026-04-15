import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:flutter/material.dart';

class CustomDatePickerModelSheet extends StatefulWidget {
  final DateTime? selectedDate;

  const CustomDatePickerModelSheet({super.key, this.selectedDate});

  @override
  State<CustomDatePickerModelSheet> createState() =>
      _CustomDatePickerModelSheetState();
}

class _CustomDatePickerModelSheetState
    extends State<CustomDatePickerModelSheet> {
  late DateTime tempDate;

  @override
  void initState() {
    super.initState();
    tempDate = widget.selectedDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Select Date", style: AppStylesManger.font16BoldBlack),
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ColorsManger.green57,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: CalendarDatePicker(
              initialDate: tempDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              onDateChanged: (date) {
                setState(() => tempDate = date);
                Navigator.pop(context, tempDate);
              },
            ),
          ),
        ],
      ),
    );
  }
}
