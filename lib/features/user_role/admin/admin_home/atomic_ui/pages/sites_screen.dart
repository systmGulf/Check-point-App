import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/customer_cubit/customer_cubit.dart';
import '../organism/add_site_bottom_sheet.dart';
import '../organism/site_screen_body.dart';

class SitesScreen extends StatelessWidget {
  const SitesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton:CustomFloatingActionButton(text: 'Add Site'.tr(), onTap: (){
          showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                builder: (_) {
                  return BlocProvider.value(
                    value: context.read<CustomerCubit>(),
                    child: const AddSiteBottomSheet(),
                  );
                });
        }),
        body: const SiteScreenBody());
  }
}
