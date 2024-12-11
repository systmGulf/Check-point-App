import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/admin/data/models/add_employee_model/add_account_request_model.dart';

import '../../../../../../core/styles/colors.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../organism/add_employee_bottom_sheet.dart';
import '../organism/all_users_list_view.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key, this.addAccountRequestValue});

  final AddAccountRequestData? addAccountRequestValue;

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  bool _isBottomSheetOpened = false;
  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isBottomSheetOpened && widget.addAccountRequestValue != null) {
      _isBottomSheetOpened = true;

      Future.delayed(Duration.zero, () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          builder: (cnx) {
            return BlocProvider.value(
              value: context.read<EmployeeCubit>(),
              child: AddEmployeeBottomSheet(
                requestId: widget.addAccountRequestValue!.id,
                name: widget.addAccountRequestValue!.name,
                mobileId: widget.addAccountRequestValue!.mobileId,
                deviceToken: widget.addAccountRequestValue!.deviceToken,
              ),
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsManger.primaryColor,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            builder: (cnx) {
              return BlocProvider.value(
                value: context.read<EmployeeCubit>(),
                child: AddEmployeeBottomSheet(
                  name: widget.addAccountRequestValue?.name,
                  mobileId: widget.addAccountRequestValue?.mobileId,
                  deviceToken: widget.addAccountRequestValue?.deviceToken,
                ),
              );
            },
          );
        },
        child: SizedBox(
          height: 25,
          width: 25,
          child: Center(child: Image.asset('assets/images/icon-dskh.png')),
        ),
      ),
      appBar: buildCustomAppBar(
        context,
        'All Users'.tr(context: context),
      ),
      body: const AllUsersListView(),
    );
  }
}
