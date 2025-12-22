import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';

Future<dynamic> buildAddPoliceTimeDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        backgroundColor: Colors.white ,
        title: Text('Select Time Range to this police'
            .tr(context: context), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Expanded(
                 child: TextButton(onPressed: () {
                  showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                         
                      ).then((selectedTime) {
                        if (selectedTime != null) {
                          context.read<ShiftsAndPolicesCubit>().clockInTime =
                              "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}:00";
                        }
                      });
                 }, child: Container(
                  height: 40,
                 
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Center(child: Text('From  ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), )))),
               ),
                SizedBox(width: 20,),
                Expanded(
                  child: TextButton(onPressed: (){
                     showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                         
                      ).then((selectedTime) {
                        if (selectedTime != null) {
                          context.read<ShiftsAndPolicesCubit>().clockOutTime =
                              "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}:00";
                        }
                        context.read<ShiftsAndPolicesCubit>().year = DateTime.now().year.toString();
                          context.read<ShiftsAndPolicesCubit>().mounth = DateTime.now().month.toString();
                      });
                  }, child: Container(
                  height: 40,
                    
                  padding: const EdgeInsets.symmetric(),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(5)
                  ),
                    child: Center(child: Text('To  ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)))),
                )
              ],
            ),
            verticalSpace(10),
            Text('Please make sure that the time range does not overlap with existing shift time ranges.'
                .tr(context: context), style: TextStyle(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
             
              
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'.tr(context: context), style: TextStyle(color: Colors.red),),
          ),
          TextButton(
            onPressed: () {
              context.read<ShiftsAndPolicesCubit>().addPolice();
              Navigator.of(context).pop();
            },
            child: Text('Save'.tr(context: context), style: TextStyle(color: Colors.black),),
          ),
        ],
      );
    },
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    useRootNavigator: true,
    routeSettings: RouteSettings(
      name: 'AddPoliceTimeDialog',
    )
  );
    }
    
  