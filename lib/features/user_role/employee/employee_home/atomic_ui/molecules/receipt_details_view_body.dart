import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/atoms/custom_invoice_image_container.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/atoms/custom_receipt_details_and_status_container.dart';
import 'package:flutter/material.dart';


class ReceiptDetailsViewBody extends StatelessWidget {
  const ReceiptDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomReceiptDetailsAndStatusContainer(
            amount: "1,000 EGP",
            date: "June 12, 2025",
            discription: "Meeting with client to discuss about the project",
            status: "Pending",
            title: "Total Amount".tr(context: context),
          ),
          verticalSpace(30),
          CustomInvoiceImageContainer(),
        ],
      ),
    );
  }
}
