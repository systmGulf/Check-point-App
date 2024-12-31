import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/enums/customer_type.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../../../admin/admin_home/controllers/customer_cubit/customer_cubit.dart';
import '../../contoller/plan_cubit/plan_cubit.dart';
import '../atoms/selectable_customer_list_tile.dart';
import 'multi_select_drop_down.dart';
import 'set_sub_plan_list_view.dart';

class AddSubPlanBottomSheet extends StatefulWidget {
  const AddSubPlanBottomSheet({super.key});

  @override
  State<AddSubPlanBottomSheet> createState() => _AddSubPlanBottomSheetState();
}

class _AddSubPlanBottomSheetState extends State<AddSubPlanBottomSheet> {
  String planType = 'Customer';

  @override
  @override
  void initState() {
    super.initState();
    context.read<PlanCubit>().customerId = '';
    context.read<PlanCubit>().dropdownItems = [];
    context.read<PlanCubit>().noteController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close),
                  )),
              Text(
                'Set Sub Plan'.tr(context: context),
                style: AppStylesManger.font16BoldBlack,
              ),
              verticalSpace(10),
              verticalSpace(5),
              PlanTypeBar(
                onChange: (index) {
                  context.read<CustomerCubit>().getCustomersByType(
                      customerType: index == 0
                          ? CustomerType.Customer
                          : CustomerType.Site);
                  ();
                  setState(() {
                    planType = index == 0 ? 'Customer' : 'Site';
                  });
                },
              ),
              verticalSpace(10),
              SelectableCustomerList(
                planType: planType,
              ),
              verticalSpace(10),
              Divider(
                thickness: 1,
                color: ColorsManger.primaryColor,
              ),
              const IntrinsicHeight(child: MultiSelectEmployeesDropdown()),
              verticalSpace(10),
              CustomAppTextFormField(
                  controller: context.read<PlanCubit>().noteController,
                  maxLines: 3,
                  hint: 'Note'.tr(context: context)),
              verticalSpace(10),
              CustomAppButton(
                onPressed: () {
                  context.read<PlanCubit>().setSubPlan();
                },
                textButton: 'Add'.tr(context: context),
                buttonColor: ColorsManger.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
