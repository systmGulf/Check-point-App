
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import '../molecules/police_item.dart';
import 'add_police_bloc_listener.dart';

class PoliceScreenBody extends StatelessWidget {
  const PoliceScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: ListView(
            children: [
              BlocBuilder<ShiftsAndPolicesCubit, ShiftsAndPolicesState>(
                buildWhen: (previous, current) =>
                    current is GetPoliceByShiftIDLoading ||
                    current is GetPoliceByShiftIDSuccess ||
                    current is GetPoliceByShiftIDError,
                builder: (context, state) {
                  if (state is GetPoliceByShiftIDLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is GetPoliceByShiftIDSuccess) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.policeResponse.value!.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PoliceItem(policeId: state.policeResponse.value!.data![index].id ?? 00,
                              year: state
                                  .policeResponse.value!.data![index].year
                                  .toString(),
                              month: state
                                  .policeResponse.value!.data![index].month
                                  .toString(),
                              timeIn: state.policeResponse.value!.data![index]
                                  .clockInTime
                                  .toString()
                                  .substring(0, 5),
                              timeOut: state.policeResponse.value!.data![index]
                                  .clockOutTime
                                  .toString()
                                  .substring(0, 5),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: Text('No Police'),
                    );
                  }
                },
              ),
              AddPoliceBlocListener(),
            ],
          ),
        );
  }
}