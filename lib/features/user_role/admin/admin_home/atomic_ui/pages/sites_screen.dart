import '../../../../../../core/styles/colors.dart';
import '../organism/add_site_bottom_sheet.dart';
import '../../controllers/customer_cubit/customer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../organism/site_screen_body.dart';

class SitesScreen extends StatelessWidget {
  const SitesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () {
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
          },
          child: SizedBox(
              height: 40.h,
              child: Image.asset(
                'assets/images/location.png',
                color: ColorsManger.primaryColor,
              )),
        ),
        body: const SiteScreenBody());
  }
}
