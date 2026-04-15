import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/widgets/build_custom_app_bar.dart';

class HolidaysScreen extends StatelessWidget {
  const HolidaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildCustomAppBar(context, 'Holidays'.tr(context: context)),
        body: Center(child: Image.asset(Assets.assetsImagesNodata)));
  }
}
