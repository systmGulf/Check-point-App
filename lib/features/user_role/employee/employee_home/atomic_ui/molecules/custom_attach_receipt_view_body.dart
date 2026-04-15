import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/routing/routes.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:employee_mangement/core/widgets/custom_app_text_form_field.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/atoms/custom_upload_image_container.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/atoms/custom_uploaded_image_container_item.dart';
import 'package:flutter/material.dart';

class CustomAttachReceiptViewBody extends StatelessWidget {
  const CustomAttachReceiptViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Amount".tr(context: context),
            style: AppStylesManger.font16BoldBlack,
          ),
          verticalSpace(8),

          /// Edit Prefix Icon Container
          CustomAppTextFormField(
            hint: "0,00",
            hintStyle: AppStylesManger.font14regulargray.copyWith(
              color: const Color(0xffA7A7A7),
            ),
            prefixIcon: Container(
              margin: EdgeInsets.only(left: 1),
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xffE5E7EB),
                borderRadius: BorderRadius.only(
                  topLeft: context.locale.languageCode == 'en'
                      ? const Radius.circular(16)
                      : Radius.zero,
                  bottomLeft: context.locale.languageCode == 'en'
                      ? const Radius.circular(16)
                      : Radius.zero,
                  topRight: context.locale.languageCode == 'ar'
                      ? const Radius.circular(16)
                      : Radius.zero,
                  bottomRight: context.locale.languageCode == 'ar'
                      ? const Radius.circular(16)
                      : Radius.zero,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "EGP",
                style: AppStylesManger.font14regulargray.copyWith(
                  color: const Color(0xff4A4A4A),
                ),
              ),
            ),
          ),
          verticalSpace(24),
          Text(
            "Description / Notes".tr(context: context),
            style: AppStylesManger.font16BoldBlack,
          ),
          verticalSpace(8),
          CustomAppTextFormField(
            hint: "Enter details here".tr(context: context),
            maxLines: 5,
            hintStyle: AppStylesManger.font14regulargray.copyWith(
              color: const Color(0xffA7A7A7),
            ),
          ),
          verticalSpace(24),
          CustomUploadImageContainer(),
          verticalSpace(16),
          CustomUploadedImageContainerItem(),
          Spacer(),
          CustomAppButton(
            textButton: "Submit".tr(context: context),
            onPressed: () {
              context.pushName(Routes.receiptDetailsScreen);
            },
            buttonColor: ColorsManger.primaryColorLight,
          ),
          verticalSpace(24),
        ],
      ),
    );
  }
}
