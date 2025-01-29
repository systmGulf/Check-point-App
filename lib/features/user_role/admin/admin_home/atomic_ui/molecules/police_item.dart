import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import 'add_employees_to_police_model_botttom_sheet.dart';

class PoliceItem extends StatelessWidget {
  const PoliceItem({
    super.key,
    required this.month,
    required this.year,
    required this.timeIn,
    required this.timeOut,
    required this.policeId,
  });
  final String month, year, timeIn, timeOut;
  final int policeId;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text('Date'.tr(context: context),
                        style: AppStylesManger.font16BoldBlack),
                    Text('$month/$year',
                        style: AppStylesManger.font16BoldBlack),
                  ],
                ),
                const Spacer(),
                // IconButton(onPressed: () {
                //   showDialog(context: context, builder: (_) {
                //     return Container(
                //       padding: const EdgeInsets.all(10),
                //       height: 100.h,
                //       width: 100.w,
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(10),

                //       )
                //       ,child: Column(
                //         children: [
                //           Row(
                //             children: [
                //              IconButton(onPressed: () => Navigator.pop(context), icon:  Icon(Icons.arrow_back_ios),),
                //               Text('Employees in this Police'.tr(context: context), style: AppStylesManger.font16BoldBlack,),
                //             ],
                            
                //           )
                //         ],
                //       ),
                //     );
                //   });
                // }, icon: Icon(
                //   Icons.visibility,
                //   size: 20,
                //   color: Colors.grey,
                // ),),
             
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: context.read<EmployeeCubit>()
                                  ..getAllEmployees(),
                              ),
                              BlocProvider.value(
                            value: context.read<ShiftsAndPolicesCubit>(),
                          ),
                            ],
                            child: AddEmployeesToPoliceyModelBottomSheet(
                                policeId: policeId),
                          );
                        });
                  },
                  child: Text(
                    'ADD EMPLOYEES'.tr(context: context),
                    style: AppStylesManger.font13DarkBlueMedium.copyWith(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      context
                          .read<ShiftsAndPolicesCubit>()
                          .deletePolice(id: policeId);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ))
              ],
            ),
            verticalSpace(10.h),
            Row(children: [
              Expanded(
                child: Container(
                  height: 150.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Time in'.tr(context: context),
                          style: AppStylesManger.font20MediumBlack),
                      Text('$timeIn', style: AppStylesManger.font38BoldBlack),
                    ],
                  ),
                ),
              ),
              horizontalSpace(10.w),
              Expanded(
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Time out'.tr(context: context),
                          style: AppStylesManger.font20MediumBlack),
                      Text('$timeOut', style: AppStylesManger.font38BoldBlack),
                    ],
                  ),
                ),
              )
            ]),
          ],
        ));
  }
}
