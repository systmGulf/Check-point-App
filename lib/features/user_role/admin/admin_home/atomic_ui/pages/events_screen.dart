import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, 'Events'.tr(context: context)),
      body: Center(child: Image.asset('assets/images/nodata.jpg')),
    );
  }
}
