import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:from_to_time_picker/from_to_time_picker.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';

class PoliceScreen extends StatelessWidget {
  const PoliceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildCustomAppBar(context, 'Police'.tr(context: context)),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorsManger.primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => FromToTimePicker(
                onTab: (from, to) {
                  print('from ${from} to $to');
                },
                dialogBackgroundColor: Color(0xFF121212),
                fromHeadlineColor: Colors.white,
                toHeadlineColor: Colors.white,
                upIconColor: Colors.white,
                downIconColor: Colors.white,
                timeBoxColor: Color(0xFF1E1E1E),
                timeHintColor: Colors.grey,
                timeTextColor: Colors.white,
                dividerColor: Color(0xFF121212),
                doneTextColor: Colors.white,
                dismissTextColor: Colors.white,
                defaultDayNightColor: Color(0xFF1E1E1E),
                defaultDayNightTextColor: Colors.white,
                colonColor: Colors.white,
                showHeaderBullet: true,
                headerText:
                    'Select Time Range to this police'.tr(context: context),
              ),
            );
          },
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Time in',
                                style: AppStylesManger.font20MediumBlack),
                            Text('10', style: AppStylesManger.font38BoldBlack),
                            Text('00', style: AppStylesManger.font38BoldBlack),
                          ],
                        ),
                      ),
                    ),
                    horizontalSpace(10.w),
                    Expanded(
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Time out',
                                style: AppStylesManger.font20MediumBlack),
                            Text('05', style: AppStylesManger.font38BoldBlack),
                            Text('00', style: AppStylesManger.font38BoldBlack),
                          ],
                        ),
                      ),
                    )
                  ]))
            ],
          ),
        ));
  }
}
