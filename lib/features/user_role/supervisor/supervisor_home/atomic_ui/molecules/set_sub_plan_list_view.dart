import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/app_action_icon_button.dart';
import 'package:employee_mangement/core/common/app_container_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/get_plan_by_id_model.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_alart_message.dart';
import '../../../../../../core/widgets/employee_assigned_widget.dart';
import '../../contoller/plan_cubit/plan_cubit.dart';

class GetSubPlanListView extends StatefulWidget {
  const GetSubPlanListView({
    super.key,
    required this.planModel,
    required this.planType,
    this.selectedStatus,
  });
  final GetPlanByIdValue planModel;
  final String planType;
  final bool? selectedStatus;

  @override
  State<GetSubPlanListView> createState() => _GetSubPlanListViewState();
}

class _GetSubPlanListViewState extends State<GetSubPlanListView> {
  List<CustomerPlans> _filterSubPlans(List<CustomerPlans> subPlans) {
    if (widget.selectedStatus == null) return subPlans;
    return subPlans.where((subPlan) {
      final matchesStatus = widget.selectedStatus == null ||
          subPlan.visited == widget.selectedStatus;

      return matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final subPlan = _filterSubPlans(widget.planModel.customerPlans!);
    return ElasticInUp(
      child: ListView.builder(
        itemCount: _filterSubPlans(widget.planModel.customerPlans!).length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return widget
                      .planModel.customerPlans![index].customer!.customerType ==
                  widget.planType
              ? Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: AppContainerDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${"Plan Date".tr()}: ${widget.planModel.planDate!.substring(0, 10)}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            if (widget.planType != 'Customer')
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: AppActionIconButton.delete(
                                  onPressed: () {
                                    buildDeleteAlertDialog(context,
                                        title: 'Delete Sub Plan'
                                            .tr(),
                                        message:
                                            'Are you sure you want to delete this Sub Plan?'
                                                .tr(), onYes: () {
                                      context.pop();
                                      context.read<PlanCubit>().deleteSubPlan(
                                          planId: widget.planModel.id!,
                                          id: subPlan[index].id!);
                                    });
                                  },
                                  size: 30,
                                ),
                              )
                          ],
                        ),
                        verticalSpace(8),
                        Text(
                            "${"Note".tr()}: ${subPlan[index].note}"),
                        verticalSpace(8),
                        Text(
                          "${"Visited".tr()}: ${subPlan[index].visited! ? "Yes".tr() : "No".tr()} ",
                          style: AppStylesManger.font15BoldBlue.copyWith(
                              color: subPlan[index].visited == true
                                  ? Colors.green
                                  : Colors.red),
                        ),
                        const SizedBox(height: 8),
                        if (subPlan.isNotEmpty) ...[
                          Text(
                            "${widget.planType.tr()}: ${subPlan[index].customer!.name}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                              "${"Work As".tr()}: ${subPlan[index].customer!.workesAs}"),
                          Text(
                              "${"Location".tr()}: ${subPlan[index].customer!.location}"),
                        ],
                        const Divider(),
                        ExpansionTile(
                          iconColor: Colors.red,
                          collapsedIconColor: Colors.black,
                          tilePadding: const EdgeInsets.all(0),
                          leading: const Icon(Icons.person),
                          visualDensity: VisualDensity.comfortable,
                          title: Text(
                            "${"Employees who will visit".tr()} (${widget.planModel.customerPlans![index].employees!.length}):"
                                .tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                          children: widget
                              .planModel.customerPlans![index].employees!
                              .map((employee) {
                            return EmployeeAssignedWidget(
                              departmentName:
                                  employee.departmentName ?? "Unknown",
                              name: employee.userName ??
                                  employee.name ??
                                  "Unknown",
                              position: employee.position ?? "Unknown",
                              imageUrl: employee.imageUrl ?? '',
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }
}

class PlanTypeBar extends StatefulWidget {
  const PlanTypeBar({super.key, required this.onChange});
  final ValueChanged<int> onChange;
  @override
  State<PlanTypeBar> createState() => _PlanTypeBarState();
}

int selectedIndex = 0;

class _PlanTypeBarState extends State<PlanTypeBar> {
  @override
  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    List<String> barText = [
      'Customer'.tr(),
      'Site'.tr()
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: barText
            .asMap()
            .entries
            .map((e) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = e.key;
                      widget.onChange(selectedIndex);
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(barText[e.key],
                          style: selectedIndex == e.key
                              ? AppStylesManger.font14RegularBlack
                                  .copyWith(color: ColorsManger.primaryColor)
                              : AppStylesManger.font14RegularBlack
                                  .copyWith(color: ColorsManger.grey)),
                      SizedBox(height: 8.h),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Divider(
                          color: selectedIndex == e.key
                              ? ColorsManger.primaryColor
                              : ColorsManger.grey,
                          thickness: 1.9,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
