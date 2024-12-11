import 'package:flutter/material.dart';

import 'get_all_employees_bloc_builder.dart';

class UsersList extends StatelessWidget {
  const UsersList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GetAllEmployeesBlocBuilder(),
    );
  }
}
