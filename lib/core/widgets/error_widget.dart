
import 'package:employee_mangement/core/widgets/no_interet_connextion_widget.dart';
import 'package:flutter/material.dart';

import '../helpers/app_spaces.dart';

class CustomErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const CustomErrorWidget({Key? key, required this.error, required this.onRetry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (error == 'Please check your internet connection') {
      return NoInternetConnectionWidget(onPressed: onRetry);
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red),
            verticalSpace(20),
            Text(error),
          ],
        ),
      );
    }
  }
}