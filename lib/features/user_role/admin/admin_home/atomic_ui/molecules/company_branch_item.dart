import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/widgets/build_alart_message.dart';
import '../../controllers/branch_cubit/branch_cubit.dart';

class CompanyBranchItem extends StatelessWidget {
  const CompanyBranchItem(
      {super.key,
      required this.name,
      required this.location,
      required this.decoration,
      required this.departmentId});
  final String name, location, decoration;
  final int departmentId;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.asset('assets/images/Branch Office.png',
                height: 30, width: 30),
            horizontalSpace(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  verticalSpace(5),
                  Text(
                    location,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  verticalSpace(5),
                  Text(
                    decoration,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                buildAlertDialog(context,
                    title: 'Delete Branch'.tr(context: context),
                    message: 'Are you sure you want to delete this branch?'.tr( context: context),
                    onYes: () {
                  context.pop();
                  BlocProvider.of<BranchCubit>(context).deleteBranch(
                    departmentId,
                  );
                });
              },
              icon: SizedBox(
                  height: 24,
                  width: 24,
                  child: Center(
                      child:
                          SvgPicture.asset('assets/images/delete_icon.svg'))),
            ),
          ],
        ),
      ),
    );
  }
}
