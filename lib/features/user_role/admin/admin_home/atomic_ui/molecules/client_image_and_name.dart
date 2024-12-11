import 'package:flutter/material.dart';

class ClientImageAndName extends StatelessWidget {
  const ClientImageAndName(
      {super.key, required this.name, required this.workedAs});
  final String name;
  final String workedAs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage:
              const AssetImage('assets/images/icon-default-user.png'),
          backgroundColor: Colors.grey[200],
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          workedAs,
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
