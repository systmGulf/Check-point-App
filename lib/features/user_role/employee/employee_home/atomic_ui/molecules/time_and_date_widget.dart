import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/styles/styles.dart';

class TimeAndDateWidet extends StatelessWidget {
  const TimeAndDateWidet({super.key});

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat(
        tr('date_format', context: context), context.locale.toString());
    DateFormat timeFormat = DateFormat(
        tr('time_format', context: context), context.locale.toString());

    return Column(children: [
      Container(
        margin: const EdgeInsets.only(top: 0, bottom: 12),
        alignment: Alignment.center,
        child: StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              return Text(
                timeFormat.format(DateTime.now()),
                style: AppStylesManger.font38BoldBlack,
              );
            }),
      ),
      Container(
        margin: const EdgeInsets.only(top: 0, bottom: 10),
        alignment: Alignment.center,
        child: Text(
          dateFormat.format(DateTime.now()),
          style: AppStylesManger.font18RegulerBlack,
        ),
      )
    ]);
  }
}
