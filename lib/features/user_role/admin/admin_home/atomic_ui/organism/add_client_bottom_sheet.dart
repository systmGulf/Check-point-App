import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

import '../../../../../../core/enums/customer_type.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../controllers/customer_cubit/customer_cubit.dart';
import '../molecules/select_location_of_client_bottom_sheet.dart';
import 'add_customer_bloc_listener.dart';

class AddClientBottomSheet extends StatefulWidget {
  const AddClientBottomSheet({super.key});

  @override
  State<AddClientBottomSheet> createState() => _AddClientBottomSheetState();
}

class _AddClientBottomSheetState extends State<AddClientBottomSheet> {
  @override
  void initState() {
    BlocProvider.of<CustomerCubit>(context).nameController =
        TextEditingController();
    BlocProvider.of<CustomerCubit>(context).workedAsController =
        TextEditingController();
    BlocProvider.of<CustomerCubit>(context).customersLocation = [];
    BlocProvider.of<CustomerCubit>(context).locationController =
        TextEditingController();
    super.initState();
  }

  @override
  build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: BlocProvider.of<CustomerCubit>(context).formKey,
        child: IntrinsicHeight(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(20),
                  )),
              child: Center(
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close),
                        )),
                    SizedBox(
                      child: Text(
                        'Add New Client'.tr(context: context),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorsManger.primaryColor,
                            fontSize: 16),
                      ),
                    ),
                    verticalSpace(7),
                    CustomAppTextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Name can't be empty".tr(context: context);
                        }
                        return null;
                      },
                      controller: BlocProvider.of<CustomerCubit>(context)
                          .nameController,
                      hint: 'Name'.tr(context: context),
                    ),
                    verticalSpace(7),
                    CustomAppTextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Worked as can't be empty"
                              .tr(context: context);
                        }
                        return null;
                      },
                      controller: BlocProvider.of<CustomerCubit>(context)
                          .workedAsController,
                      hint: 'Worked as'.tr(context: context),
                    ),
                    verticalSpace(7),
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
                    CustomAppTextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Location can't be empty".tr(context: context);
                        }
                        return null;
                      },
                      controller: BlocProvider.of<CustomerCubit>(context)
                          .locationController,
                      hint: 'Location'.tr(context: context),
                    ),
                    verticalSpace(7),
                    CustomAppButton(
                        textButton: 'Submit'.tr(context: context),
                        buttonColor: ColorsManger.primaryColor,
                        onPressed: () {
                          if (BlocProvider.of<CustomerCubit>(context)
                              .formKey
                              .currentState!
                              .validate()) {
                            if (context
                                .read<CustomerCubit>()
                                .customersLocation
                                .isNotEmpty) {
                              BlocProvider.of<CustomerCubit>(context)
                                  .addCustomer(
                                      customerType: CustomerType.Customer);
                            } else {
                              showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.error(
                                  message: 'Please Select Location'
                                      .tr(context: context),
                                  // backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }),
                    const AddCustomerBlocListener()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
