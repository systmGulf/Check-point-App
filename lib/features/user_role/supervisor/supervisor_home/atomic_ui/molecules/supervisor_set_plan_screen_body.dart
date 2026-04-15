import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:employee_mangement/core/widgets/custom_floating_action_button.dart';
import 'package:employee_mangement/core/widgets/no_interet_connextion_widget.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/molecules/supervisor_set_plan_loading_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../../../../../core/widgets/no_data_found_animation_widget.dart';
import '../../contoller/plan_cubit/plan_cubit.dart';
import '../atoms/plan_item.dart';
import '../pages/sub_plans_screen.dart';
import 'add_plan_bottom_sheet.dart';

class SetPlanScreen extends StatelessWidget {
  const SetPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlansScreen();
  }
}

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(
          text: 'Add Plan'.tr(context: context),
          onTap: () {
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
          }),
      body: BlocBuilder<PlanCubit, PlanState>(
        buildWhen: (previous, current) =>
            current is GetPlanSuccess ||
            current is GetPlanError ||
            current is GetPlanLoading,
        builder: (context, state) {
          if (state is GetPlanError) {
            return state.error == 'Please check your internet connection'
                ? NoInternetConnectionWidget(onPressed: () {
                    context.read<PlanCubit>().getPlan();
                  })
                : Column(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      verticalSpace(20),
                      Text(state.error)
                    ],
                  );
          }
          if (state is GetPlanSuccess) {
            final filterList = state.planModel.data!
                .where(
                  (element) => element.planDate!.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();

            final plan =
                filterList.isEmpty ? state.planModel.data! : filterList;
            return state.planModel.data!.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      context.read<PlanCubit>().getPlan();
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CustomAppTextFormField(
                            onChanged: (value) {
                              setState(() {
                                query = value;
                                log("query: $query");
                              });
                            },
                            hint: "Search a plan...".tr(context: context),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SvgPicture.asset(
                                Assets.assetsImagesSearchIcon,
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElasticInUp(
                            child: ListView.builder(
                                itemCount: plan.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    spacing: 16,
                                    children: [
                                      PlanItem(
                                        planId: plan[index].id!,
                                        planDate: plan[index].planDate ?? '',
                                        note: plan[index].note ?? '',
                                        onTap: () {
                                          context.read<PlanCubit>().planId =
                                              plan[index].id!;
                                          log(state.planModel.data![index].id!
                                              .toString());
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return BlocProvider.value(
                                              value: context.read<PlanCubit>()
                                                ..getPlanById(
                                                    id: plan[index].id!),
                                              child: SubPlansScreen(
                                                planId: plan[index].id!,
                                              ),
                                            );
                                          }));
                                        },
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ),
                      ],
                    ))
                : NoDataFound();
          }
          return const SupervisorSetPlanLoadingSkeleton();
        },
      ),
    );
  }
}
