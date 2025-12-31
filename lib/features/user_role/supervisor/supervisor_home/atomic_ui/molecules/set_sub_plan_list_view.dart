import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return ListView.builder(
      itemCount: _filterSubPlans(widget.planModel.customerPlans!).length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return widget.planModel.customerPlans![index].customer!.customerType ==
                widget.planType
            ? Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    )),
                color: Colors.white,
                margin: const EdgeInsets.all(8.0),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${"Plan Date".tr(context: context)}: ${widget.planModel.planDate!.substring(0, 10)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: InkWell(
                              onTap: () {
                                buildDeleteAlertDialog(context,
                                    title:
                                        'Delete Sub Plan'.tr(context: context),
                                    message:
                                        'Are you sure you want to delete this Sub Plan?'
                                            .tr(context: context), onYes: () {
                                  context.pop();
                                  context.read<PlanCubit>().deleteSubPlan(
                                      planId: widget.planModel.id!,
                                      id: _filterSubPlans(widget
                                              .planModel.customerPlans!)[index]
                                          .id!);
                                });
                              },
                              child: SvgPicture.asset(
                                  'assets/images/delete_icon.svg',
                                  height: 24.h),
                            ),
                          )
                        ],
                      ),
                      verticalSpace(8),
                      Text(
                          "${"Note".tr(context: context)}: ${_filterSubPlans(widget.planModel.customerPlans!)[index].note}"),
                      verticalSpace(8),
                      Text(
                        "${"Visited".tr(context: context)}: ${widget.planModel.customerPlans![index].visited! ? "Yes".tr(context: context) : "No".tr(context: context)} ",
                        style: AppStylesManger.font15BoldBlue.copyWith(
                            color: widget.planModel.customerPlans![index]
                                        .visited ==
                                    true
                                ? Colors.green
                                : Colors.red),
                      ),
                      const SizedBox(height: 8),
                      if (widget.planModel.customerPlans!.isNotEmpty) ...[
                        Text(
                          "${widget.planType.tr(context: context)}: ${_filterSubPlans(widget.planModel.customerPlans!)[index].customer!.name}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                            "${"Work As".tr(context: context)}: ${_filterSubPlans(widget.planModel.customerPlans!)[index].customer!.workesAs}"),
                        Text(
                            "${"Location".tr(context: context)}: ${_filterSubPlans(widget.planModel.customerPlans!)[index].customer!.location}"),
                      ],
                      const Divider(),
                      ExpansionTile(
                        iconColor: Colors.red,
                        collapsedIconColor: Colors.black,
                        tilePadding: const EdgeInsets.all(0),
                        leading: const Icon(Icons.person),
                        visualDensity: VisualDensity.comfortable,
                        title: Text(
                          "${"Employees who will visit".tr(context: context)} (${widget.planModel.customerPlans![index].employees!.length}):"
                              .tr(context: context),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),
                        children: widget
                            .planModel.customerPlans![index].employees!
                            .map((employee) {
                          return EmployeeAssignedWidget(
                            departmentName:
                                employee.departmentName ?? "Unknown",
                            name: employee.name ?? "Unknown",
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
      'Customer'.tr(context: context),
      'Site'.tr(context: context)
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
