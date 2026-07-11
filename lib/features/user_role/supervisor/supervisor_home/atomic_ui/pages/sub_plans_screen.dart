import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/custom_filter_floating_action_button.dart';
import 'package:employee_mangement/core/widgets/custom_floating_action_button.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/dependency%D9%80injection/register%D9%80factory.dart';
import '../../../../../../core/enums/customer_type.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/custom_filter_container.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../../../admin/admin_home/controllers/customer_cubit/customer_cubit.dart';
import '../../contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import '../../contoller/plan_cubit/plan_cubit.dart';
import '../molecules/add_sub_plan_bloc_listener.dart';
import '../molecules/add_sub_plan_bottom_sheet.dart';
import '../molecules/set_sub_plan_list_view.dart';

class SubPlansScreen extends StatefulWidget {
  const SubPlansScreen({super.key, required this.planId});
  final int planId;

  @override
  State<SubPlansScreen> createState() => _SubPlansScreenState();
}

bool? selectedStatus;

class _SubPlansScreenState extends State<SubPlansScreen> {
  String planType = 'Customer';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            CustomFilterFloatingActionButton(
              onPressed: () async {
                final filterData =
                    await showModalBottomSheet<Map<String, dynamic>>(
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  context: context,
                  builder: (ctx) {
                    return CustomFilterContainer(
                        statusOne: "Visted".tr(
                          context: context,
                        ),
                        statusTwo: "Not Visited".tr(
                          context: context,
                        ),
                        statusThree: "Expired".tr(
                          context: context,
                        ));
                  },
                );

                if (filterData != null) {
                  setState(() {
                    if (filterData['statusOne'] == true) {
                      selectedStatus = true;
                    } else if (filterData['statusTwo'] == true) {
                      selectedStatus = false;
                    } else {
                      selectedStatus = null;
                    }
                  });
                }
              },
            ),
            CustomFloatingActionButton(
                text: 'Add Plan'.tr(),
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
                      return MultiBlocProvider(providers: [
                        BlocProvider.value(value: context.read<PlanCubit>()),
                        BlocProvider(
                            create: (_) => getIt<GetEmployeesDataCubit>()
                              ..getEmployeesByDepartmentId()),
                        BlocProvider(
                            create: (_) => getIt<CustomerCubit>()
                              ..getCustomersByType(
                                  isLoading: false,
                                  customerType: CustomerType.Customer))
                      ], child: const AddSubPlanBottomSheet());
                    },
                  );
                }),
          ],
        ),
        appBar: buildCustomAppBar(
          context,
          'Plans For this Day'.tr(),
        ),
        body: Column(
          children: [
            PlanTypeBar(
              onChange: (index) {
                setState(() {
                  planType = index == 0 ? 'Customer' : 'Site';
                });
              },
            ),
            BlocBuilder<PlanCubit, PlanState>(
              buildWhen: (previous, current) =>
                  current is GetPlanByIdSuccess ||
                  current is GetPlanByIdError ||
                  current is GetPlanByIdLoading,
              builder: (context, state) {
                if (state is GetPlanByIdSuccess) {
                  return state.planModel.customerPlans!.isNotEmpty
                      ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GetSubPlanListView(
                              planType: planType,
                              planModel: state.planModel,
                              selectedStatus: selectedStatus,
                            ),
                          ),
                        )
                      : Center(child: NoDataFound());
                } else if (state is GetPlanByIdError) {
                  return state.error == 'Please check your internet connection'
                      ? NoInternetConnectionWidget(onPressed: () {
                          context
                              .read<PlanCubit>()
                              .getPlanById(id: widget.planId);
                        })
                      : Column(
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            verticalSpace(20),
                            Text(state.error)
                          ],
                        );
                } else {
                  return Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.sizeOf(context).height * 0.4),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ColorsManger.primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }
              },
            ),
            const AddPlanSubBlocListener()
          ],
        ));
  }
}
