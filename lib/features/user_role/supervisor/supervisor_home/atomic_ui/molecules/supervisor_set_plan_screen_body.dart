import 'dart:developer';

import 'package:employee_mangement/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/widgets/no_data_found_animation_widget.dart';
import '../../contoller/plan_cubit/plan_cubit.dart';
import '../atoms/plan_item.dart';
import '../pages/sub_plans_screen.dart';
import 'add_plan_bloc_listener.dart';
import 'add_plan_bottom_sheet.dart';

class SetPlanScreen extends StatelessWidget {
  const SetPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlansScreen();
  }
}

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsManger.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            builder: (_) {
              return BlocProvider.value(
                  value: context.read<PlanCubit>(),
                  child: const AddPlanBottomSheet());
            },
          );
        },
      ),
      body: BlocBuilder<PlanCubit, PlanState>(
        buildWhen: (previous, current) =>
            current is GetPlanSuccess ||
            current is GetPlanError ||
            current is GetPlanLoading,
        builder: (context, state) {
          if (state is GetPlanError) {
            return Column(
              children: [
                const Icon(Icons.error, color: Colors.red),
                verticalSpace(20),
                Text(state.error)
              ],
            );
          }
          if (state is GetPlanSuccess) {
            return state.planModel.data!.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      context.read<PlanCubit>().getPlan();
                    },
                    child: ListView.builder(
                        itemCount: state.planModel.data!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              const AddPlanBlocListener(),
                              PlanItem(
                                planId: state.planModel.data![index].id!,
                                planDate:
                                    state.planModel.data![index].planDate ?? '',
                                note: state.planModel.data![index].note ?? '',
                                onTap: () {
                                  context.read<PlanCubit>().planId =
                                      state.planModel.data![index].id!;
                                  log(state.planModel.data![index].id!
                                      .toString());
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return BlocProvider.value(
                                      value: context.read<PlanCubit>()
                                        ..getPlanById(
                                            id: state
                                                .planModel.data![index].id!),
                                      child: const SubPlansScreen(),
                                    );
                                  }));
                                },
                              ),
                            ],
                          );
                        }),
                  )
                : NoDataFound();
          }
          return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Skeletonizer(
                  child: PlanItem(
                    planId: 00,
                    planDate: '2024-11-21T00:00:00',
                    note: 'Data Load',
                    onTap: () {},
                  ),
                );
              });
        },
      ),
    );
  }
}
