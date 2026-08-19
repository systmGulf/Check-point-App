import 'package:flutter/material.dart';

/// AuthHeaderWidget is now a no-op placeholder.
/// The role label, title, and subtitle are rendered directly inside [AuthLoginBody].
class AuthHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? label;

  const AuthHeaderWidget({
    required this.title,
    required this.subtitle,
    this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
