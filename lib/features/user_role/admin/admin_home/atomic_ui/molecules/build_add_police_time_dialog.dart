import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';

Future<dynamic> buildAddPoliceTimeDialog(
  BuildContext context, {
  int? policeId,
  String? initialMonth,
  String? initialYear,
  String? initialClockInTime,
  String? initialClockOutTime,
}) {
  final cubit = context.read<ShiftsAndPolicesCubit>();
  cubit.setPoliceForm(
    month: initialMonth ?? DateTime.now().month.toString(),
    year: initialYear ?? DateTime.now().year.toString(),
    clockInTime: initialClockInTime ?? '',
    clockOutTime: initialClockOutTime ?? '',
  );

  return showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> pickTime({required bool isClockIn}) async {
            final selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (selectedTime == null) return;

            final formattedTime =
                "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}:00";

            if (isClockIn) {
              cubit.clockInTime = formattedTime;
            } else {
              cubit.clockOutTime = formattedTime;
            }
            setState(() {});
          }

          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              policeId == null
                  ? 'Select Time Range to this police'.tr()
                  : 'Edit Time Range for this police'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${cubit.mounth}/${cubit.year}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                verticalSpace(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => pickTime(isClockIn: true),
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              cubit.clockInTime.isEmpty
                                  ? 'From'.tr()
                                  : formatTime12Hour(cubit.clockInTime),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextButton(
                        onPressed: () => pickTime(isClockIn: false),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              cubit.clockOutTime.isEmpty
                                  ? 'To'.tr()
                                  : formatTime12Hour(cubit.clockOutTime),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(10),
                Text(
                  'Please make sure that the time range does not overlap with existing shift time ranges.'
                      .tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close'.tr(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (policeId == null) {
                    cubit.addPolice();
                  } else {
                    cubit.editPolice(id: policeId);
                  }
                  Navigator.of(context).pop();
                },
                child: Text(
                  policeId == null
                      ? 'Save'.tr()
                      : 'Update'.tr(),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
    },
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    useRootNavigator: true,
    routeSettings: const RouteSettings(
      name: 'AddPoliceTimeDialog',
    ),
  );
}

String formatTime12Hour(String timeStr) {
  if (timeStr.isEmpty) return '';
  try {
    final parts = timeStr.split(':');
    final int hour = int.parse(parts[0]);
    final int minute = int.parse(parts[1]);
    final String period = hour >= 12 ? 'PM' : 'AM';
    final int hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final String minuteStr = minute.toString().padLeft(2, '0');
    return '$hour12:$minuteStr $period';
  } catch (e) {
    return timeStr;
  }
}
