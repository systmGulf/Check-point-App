import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/styles/styles.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          buildCustomAppBar(context, 'Terms & Conditions'.tr(context: context)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text(
                'By purchasing HR Management App, you accept, agree and understand that you are fully responsible for your progress and results from your participation and that we offer no representations, warranties or guarantees verbally or in writing regarding your earnings, business profit, marketing performance'
                    .tr(context: context),
                style: AppStylesManger.font14RegularBlack
                    .copyWith(color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }
}
