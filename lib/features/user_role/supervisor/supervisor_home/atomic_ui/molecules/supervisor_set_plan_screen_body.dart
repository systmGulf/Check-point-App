import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:employee_mangement/core/widgets/custom_floating_action_button.dart';
import 'package:employee_mangement/core/widgets/no_interet_connextion_widget.dart';
import 'package:employee_mangement/core/dependencyـinjection/registerـfactory.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/molecules/supervisor_set_plan_loading_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../../../../../core/widgets/no_data_found_animation_widget.dart';
import '../../contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import '../../contoller/plan_cubit/plan_cubit.dart';
import '../atoms/plan_item.dart';
import '../pages/sub_plans_screen.dart';
import 'add_plan_bottom_sheet.dart';
import 'assign_plan_employees_bottom_sheet.dart';

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
            current is GetPlanLoading ||
            current is GetPlansV2Success ||
            current is GetPlansV2Error ||
            current is GetPlansV2Loading,
        builder: (context, state) {
          if (state is GetPlansV2Error) {
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
          if (state is GetPlansV2Success) {
            final filterList = state.plans
                .where(
                  (element) => (element.startDate ?? '').toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();

            final plans = query.trim().isEmpty ? state.plans : filterList;
            return plans.isNotEmpty
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
                            child: ListView.separated(
                              itemCount: plans.length,
                              separatorBuilder: (_, __) => verticalSpace(8),
                              itemBuilder: (context, index) {
                                final plan = plans[index];
                                return _PlanV2Item(
                                  title: plan.title ?? '--',
                                  startDate: plan.startDate ?? '--',
                                  endDate: plan.endDate ?? '--',
                                  notes: plan.notes ?? '',
                                  onAssign: (plan.id ?? '').isEmpty
                                      ? null
                                      : () {
                                          showModalBottomSheet(
                                            context: context,
                                            backgroundColor: Colors.white,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                            ),
                                            builder: (_) {
                                              return MultiBlocProvider(
                                                providers: [
                                                  BlocProvider.value(
                                                    value: context
                                                        .read<PlanCubit>(),
                                                  ),
                                                  BlocProvider(
                                                    create: (_) => getIt<
                                                        GetEmployeesDataCubit>()
                                                      ..getEmployeesByDepartmentId(),
                                                  ),
                                                ],
                                                child:
                                                    AssignPlanEmployeesBottomSheet(
                                                  planId: plan.id!,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ))
                : NoDataFound();
          }
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
                    child: ListView.builder(
                      itemCount: plan.length,
                      itemBuilder: (context, index) => PlanItem(
                        planId: plan[index].id!,
                        planDate: plan[index].planDate ?? '',
                        note: plan[index].note ?? '',
                        onTap: () {
                          context.read<PlanCubit>().planId = plan[index].id!;
                          log(state.planModel.data![index].id!.toString());
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return BlocProvider.value(
                              value: context.read<PlanCubit>()
                                ..getPlanById(id: plan[index].id!),
                              child: SubPlansScreen(
                                planId: plan[index].id!,
                              ),
                            );
                          }));
                        },
                      ),
                    ),
                  )
                : NoDataFound();
          }
          return const SupervisorSetPlanLoadingSkeleton();
        },
      ),
    );
  }
}

class _PlanV2Item extends StatelessWidget {
  const _PlanV2Item({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.notes,
    required this.onAssign,
  });

  final String title;
  final String startDate;
  final String endDate;
  final String notes;
  final VoidCallback? onAssign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xffE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppStylesManger.font16BoldBlack,
            ),
            verticalSpace(6),
            Text(
              'Start: $startDate',
              style: AppStylesManger.font12RegularGrey,
            ),
            Text(
              'End: $endDate',
              style: AppStylesManger.font12RegularGrey,
            ),
            if (notes.trim().isNotEmpty) ...[
              verticalSpace(8),
              Text(
                notes,
                style: AppStylesManger.font14RegularBlack,
              ),
            ],
            verticalSpace(10),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onAssign,
                  borderRadius: BorderRadius.circular(26),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: onAssign == null
                          ? const Color(0xFFF2F4F7)
                          : const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: onAssign == null
                            ? const Color(0xFFE5E7EB)
                            : const Color(0xFFD8DFFE),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_add_alt_1,
                          size: 18,
                          color: onAssign == null
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF5B56B8),
                        ),
                        horizontalSpace(8),
                        Text(
                          'Assign Employees'.tr(context: context),
                          style: AppStylesManger.font14RegularBlack.copyWith(
                            color: onAssign == null
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF5B56B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
