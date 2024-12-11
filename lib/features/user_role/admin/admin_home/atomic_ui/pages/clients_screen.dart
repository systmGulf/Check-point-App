import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/styles/colors.dart';
import '../../controllers/customer_cubit/customer_cubit.dart';
import '../organism/add_client_bottom_sheet.dart';
import '../organism/clients_body.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext cnx) {
              return BlocProvider.value(
                value: context.read<CustomerCubit>(),
                child: const AddClientBottomSheet(),
              );
            },
          );
        },
        child: SizedBox(
            height: 40.h,
            child: Image.asset(
              'assets/images/user-app.png',
              color: ColorsManger.primaryColor,
            )),
      ),
      body: const ClientsBodyScreen(),
    );
  }
}
