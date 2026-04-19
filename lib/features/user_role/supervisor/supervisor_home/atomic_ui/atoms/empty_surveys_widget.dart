import 'package:flutter/material.dart';

import '../../../../../../core/styles/styles.dart';

class EmptySurveysWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptySurveysWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppStylesManger.font16BoldBlack,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppStylesManger.font14RegularBlack,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}