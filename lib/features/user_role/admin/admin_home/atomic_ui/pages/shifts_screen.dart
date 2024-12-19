import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import '../molecules/shift_item.dart';
import '../organism/add_shifts_bottom_sheet.dart';

class ShiftsScreen extends StatelessWidget {
  const ShiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsManger.primaryColor,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            builder: (BuildContext cnx) {
              return BlocProvider.value(
                value: context.read<ShiftsAndPolicesCubit>(),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: AddShiftBottomSheet(),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar:
          buildCustomAppBar(context, 'Shifts & Polices'.tr(context: context)),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: BlocBuilder<ShiftsAndPolicesCubit, ShiftsAndPolicesState>(
            buildWhen: (previous, current) =>
                current is GetShiftsSuccess ||
                current is GetShiftsError ||
                current is GetShiftsLoading,
            builder: (context, state) {
              if (state is GetShiftsSuccess) {
                return state.shiftModel.value!.data!.isEmpty
                    ? const Center(
                        child: Text('No Shifts'),
                      )
                    : ListView.builder(
                        itemCount: state.shiftModel.value!.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: ShiftItem(
                              shiftName:
                                  state.shiftModel.value!.data![index].name!,
                            ),
                          );
                        },
                      );
              } else if (state is GetShiftsError) {
                return Center(
                  child: Text(state.error),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
  }
}
