import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

import '../../../../../../core/enums/customer_type.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../../../admin/admin_home/atomic_ui/molecules/select_location_of_client_bottom_sheet.dart';
import '../../../../admin/admin_home/atomic_ui/organism/add_customer_bloc_listener.dart';
import '../../../../admin/admin_home/controllers/customer_cubit/customer_cubit.dart';

class EmployeeAddNewCustomerScreen extends StatefulWidget {
  const EmployeeAddNewCustomerScreen({super.key});

  @override
  State<EmployeeAddNewCustomerScreen> createState() =>
      _EmployeeAddNewCustomerScreenState();
}

class _EmployeeAddNewCustomerScreenState
    extends State<EmployeeAddNewCustomerScreen> {
  late TextEditingController nameController;
  late TextEditingController workedAsController;
  late TextEditingController locationController;
  @override
  void initState() {
    super.initState();
    nameController = BlocProvider.of<CustomerCubit>(context).nameController;
    workedAsController =
        BlocProvider.of<CustomerCubit>(context).workedAsController;
    locationController =
        BlocProvider.of<CustomerCubit>(context).locationController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildCustomAppBar(
          context,
          'Add New Customer'.tr(context: context),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: BlocProvider.of<CustomerCubit>(context).formKey,
            child: IntrinsicHeight(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    verticalSpace(7),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('Customer name'.tr(context: context),
                          style: AppStylesManger.font12RegularGrey),
                    ),
                    verticalSpace(10),
                    CustomAppTextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Name can't be empty".tr(context: context);
                        }
                        return null;
                      },
                      controller: nameController,
                      hint: 'Name'.tr(context: context),
                    ),
                    verticalSpace(7),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('The Customer job'.tr(context: context),
                          style: AppStylesManger.font12RegularGrey),
                    ),
                    verticalSpace(10),
                    CustomAppTextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Worked as can't be empty"
                              .tr(context: context);
                        }
                        return null;
                      },
                      controller: workedAsController,
                      hint: 'Worked as'.tr(context: context),
                    ),
                    verticalSpace(7),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('Location'.tr(context: context),
                          style: AppStylesManger.font12RegularGrey),
                    ),
                    verticalSpace(10),
                    CustomAppTextFormField(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          enableDrag: false,
                          context: context,
                          builder: (builder) {
                            return BlocProvider.value(
                              value: context.read<CustomerCubit>(),
                              child: const SelectLocationOfClientBottomSheet(),
                            );
                          },
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      readOnly: true,
                      prefixIcon: context
                              .read<CustomerCubit>()
                              .customersLocation
                              .isEmpty
                          ? null
                          : const Icon(Icons.check_circle, color: Colors.green),
                      controller: context
                              .read<CustomerCubit>()
                              .customersLocation
                              .isEmpty
                          ? TextEditingController()
                          : TextEditingController(
                              text: 'Location Selected'.tr(context: context)),
                      hint: 'Location in Map'.tr(context: context),
                    ),
                    verticalSpace(7),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('Address'.tr(context: context),
                          style: AppStylesManger.font12RegularGrey),
                    ),
                    verticalSpace(10),
                    CustomAppTextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Location can't be empty".tr(context: context);
                        }
                        return null;
                      },
                      controller: locationController,
                      hint: 'Address'.tr(context: context),
                    ),
                    verticalSpace(15),
                    CustomAppButton(
                        textButton: 'Submit'.tr(context: context),
                        buttonColor: ColorsManger.primaryColor,
                        onPressed: () {
                          if (BlocProvider.of<CustomerCubit>(context)
                              .formKey
                              .currentState!
                              .validate()) {
                            if (BlocProvider.of<CustomerCubit>(context)
                                .customersLocation
                                .isNotEmpty) {
                              BlocProvider.of<CustomerCubit>(context)
                                  .addCustomer(
                                customerType: CustomerType.Customer,
                              );
                            } else {
                              showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.error(
                                  message: 'Please Select Location'
                                      .tr(context: context),
                                ),
                              );
                            }
                          }
                        }),
                    AddCustomerBlocListener(
                      addSuccessMessage:
                          'Customer Added Successfully'.tr(context: context),
                      editSuccessMessage:
                          'Customer Updated Successfully'.tr(context: context),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
