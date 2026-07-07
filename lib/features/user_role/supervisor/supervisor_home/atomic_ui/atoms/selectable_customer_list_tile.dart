import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';
import 'package:employee_mangement/core/widgets/app_action_icon_button.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../admin/admin_home/controllers/customer_cubit/customer_cubit.dart';
import '../../contoller/plan_cubit/plan_cubit.dart';
import '../../model/drop_down_item.dart';

class SelectableCustomerList extends StatefulWidget {
  final String planType;
  const SelectableCustomerList({
    super.key,
    required this.planType,
  });
  @override
  State<StatefulWidget> createState() => _SelectableCustomerListState();
}

class _SelectableCustomerListState extends State<SelectableCustomerList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerCubit, CustomerState>(
      buildWhen: (previous, current) =>
          current is GetAllCustomersSuccess ||
          current is GetAllCustomersError ||
          current is GetAllCustomersLoading,
      builder: (context, state) {
        if (state is GetAllCustomersLoading) {
          return Skeletonizer(
              child: const SelectCustomersForTheSubPLanDropButton(
            dropdownItems: [],
            planType: '',
          ));
        } else if (state is GetAllCustomersSuccess) {
          List<DropdownItemModel> dropdownItems = state.customers.data!
              .map((customer) => DropdownItemModel(
                    [],
                    id: customer.id ?? '',
                    name: customer.name ?? '',
                    isSelected: false,
                  ))
              .toList();
          return SelectCustomersForTheSubPLanDropButton(
            dropdownItems: dropdownItems,
            planType: widget.planType,
          );
        } else if (state is GetAllCustomersError) {
          return Text('Error loading ${widget.planType}'.tr(context: context));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class SelectCustomersForTheSubPLanDropButton extends StatefulWidget {
  const SelectCustomersForTheSubPLanDropButton(
      {super.key, required this.dropdownItems, required this.planType});
  final List<DropdownItemModel> dropdownItems;
  final String planType;
  @override
  State<SelectCustomersForTheSubPLanDropButton> createState() =>
      _SelectCustomersForTheSubPLanDropButtonState();
}

class _SelectCustomersForTheSubPLanDropButtonState
    extends State<SelectCustomersForTheSubPLanDropButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField(
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ))),
          icon: SizedBox(
              width: 24,
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/arrow_down.svg',
                  colorFilter: ColorFilter.mode(
                      ColorsManger.primaryColor, BlendMode.srcIn),
                ),
              )),
          iconEnabledColor: ColorsManger.primaryColor,
          dropdownColor: Colors.white,
          isExpanded: true,
          hint: Text(
            'Select ${widget.planType}'.tr(context: context),
            style: AppStylesManger.font15BoldBlue.copyWith(color: Colors.black),
          ),
          initialValue: widget.dropdownItems.firstWhereOrNull(
              (item) => item.id == context.read<PlanCubit>().customerId),
          items: widget.dropdownItems.map((item) {
            return DropdownMenuItem<DropdownItemModel>(
              value: item,
              child: Text(
                item.name,
                style: AppStylesManger.font15BoldBlue
                    .copyWith(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: (DropdownItemModel? selectedItem) {
            setState(() {
              if (context.read<PlanCubit>().customerId != selectedItem!.id) {
                context.read<PlanCubit>().customerId = selectedItem.id;
                log(context.read<PlanCubit>().customerId.toString());
              } else {
                showTopSnackBar(
                  Overlay.of(context),
                  CustomSnackBar.info(
                    message: "${widget.planType} is already selected"
                        .tr(context: context),
                  ),
                );
              }
            });
          },
        ),
        const SizedBox(height: 20),
        Text('Selected ${widget.planType}:'.tr(context: context)),
        const SizedBox(height: 10),
        context.read<PlanCubit>().customerId.isEmpty
            ? Text('No ${widget.planType} selected'.tr(context: context))
            : Card(
                elevation: 1,
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Image.asset('assets/images/icon-default-user.png'),
                    ),
                  ),
                  trailing: AppActionIconButton.delete(
                    onPressed: () {
                      setState(() {
                        context.read<PlanCubit>().customerId = '';
                      });
                    },
                    size: 32,
                  ),
                  title: Text(widget.dropdownItems
                          .firstWhereOrNull((element) =>
                              element.id ==
                              context.read<PlanCubit>().customerId)
                          ?.name ??
                      ""),
                ),
              ),
      ],
    );
  }
}
