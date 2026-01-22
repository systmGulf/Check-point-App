import 'package:animate_do/animate_do.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import '../atoms/shift_item.dart';
import './shift_loading_skeleton.dart';

class GetShiftsBlocBuilder extends StatelessWidget {
  const GetShiftsBlocBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShiftsAndPolicesCubit, ShiftsAndPolicesState>(
      buildWhen: (previous, current) =>
          current is GetShiftsSuccess ||
          current is GetShiftsError ||
          current is GetShiftsLoading,
      builder: (context, state) {
        if (state is GetShiftsSuccess) {
          return state.shiftModel.value!.data!.isEmpty
              ? const Center(
                  child: NoDataFound(),
                )
              : RefreshIndicator(
                  color: ColorsManger.primaryColor,
                  onRefresh: () async {
                    context
                        .read<ShiftsAndPolicesCubit>()
                        .getShifts(isLoading: true);
                  },
                  child: state.shiftModel.value!.data!.isEmpty
                      ? const Center(
                          child: NoDataFound(),
                        )
                      : FadeInUp(
                          child: ListView.builder(
                            itemCount: state.shiftModel.value!.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(top: 10.h),
                                child: ShiftItem(
                                  onAdd: () {
                                    context.pushName(
                                        Routes.addBranchsToShiftScreen,
                                        arguments: state
                                            .shiftModel.value!.data![index].id);
                                  },
                                  onTap: () {
                                    context.pushName(Routes.policeScreen,
                                        arguments: state
                                            .shiftModel.value!.data![index].id);
                                  },
                                  onDelete: () async {
                                    context
                                        .read<ShiftsAndPolicesCubit>()
                                        .deleteShift(
                                            id: state.shiftModel.value!
                                                .data![index].id!);
                                  },
                                  shiftName: state
                                      .shiftModel.value!.data![index].name!,
                                ),
                              );
                            },
                          ),
                        ),
                );
        } else if (state is GetShiftsError) {
          return state.error == 'Please check your internet connection'
              ? NoInternetConnectionWidget(onPressed: () {
                  context
                      .read<ShiftsAndPolicesCubit>()
                      .getShifts(isLoading: true);
                })
              : Column(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    verticalSpace(20),
                    Text(state.error)
                  ],
                );
        } else {
          return const ShiftLoadingSkeleton();
        }
      },
    );
  }
}
