import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/supervisor/data/models/plan_model/get_plan_by_id_model.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../core/dependency%D9%80injection/register%D9%80factory.dart';
import '../../../../../../core/enums/customer_type.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../admin/admin_home/controllers/customer_cubit/customer_cubit.dart';
import '../../contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import '../../contoller/plan_cubit/plan_cubit.dart';
import '../molecules/add_sub_plan_bloc_listener.dart';
import '../molecules/add_sub_plan_bottom_sheet.dart';
import '../molecules/set_sub_plan_list_view.dart';

class SubPlansScreen extends StatefulWidget {
  const SubPlansScreen({super.key});

  @override
  State<SubPlansScreen> createState() => _SubPlansScreenState();
}

class _SubPlansScreenState extends State<SubPlansScreen> {
  String planType = 'Customer';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorsManger.primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              builder: (_) {
                return MultiBlocProvider(providers: [
                  BlocProvider.value(value: context.read<PlanCubit>()),
                  BlocProvider(
                      create: (_) => getIt<GetEmployeesDataCubit>()
                        ..getEmployeesByDepartmentId()),
                  BlocProvider(
                      create: (_) => getIt<CustomerCubit>()
                        ..getCustomersByType(
                            customerType: CustomerType.Customer))
                ], child: const AddSubPlanBottomSheet());
              },
            );
          },
        ),
        appBar: buildCustomAppBar(
          context,
          'Plans For this Day'.tr(context: context),
        ),
        body: Column(
          children: [
            PlanTypeBar(
              onChange: (index) {
                setState(() {
                  planType = index == 0 ? 'Customer' : 'Site';
                });
              },
            ),
            BlocBuilder<PlanCubit, PlanState>(
              buildWhen: (previous, current) =>
                  current is GetPlanByIdSuccess ||
                  current is GetPlanError ||
                  current is GetPlanLoading,
              builder: (context, state) {
                if (state is GetPlanByIdSuccess) {
                  return state.planModel.customerPlans!.isNotEmpty
                      ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GetSubPlanListView(
                              planType: planType,
                              planModel: state.planModel,
                            ),
                          ),
                        )
                      : Center(
                          child: Lottie.asset(
                            'assets/animated_images/no_data_found.json'),
                        );
                } else if (state is GetPlanError) {
                  return Column(
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                      verticalSpace(20),
                      Text(state.error),
                    ],
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.sizeOf(context).height * 0.4),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ColorsManger.primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }
              },
            ),
            const AddPlanSubBlocListener()
          ],
        ));
  }
}

GetPlanByIdValue getDummyPlanByIdValue() {
  return GetPlanByIdValue(
    id: 1,
    planDate: "2024-12-05",
    note: "Sample plan note",
    customerPlans: [
      CustomerPlans(
        id: 101,
        note: "Visit for feedback",
        visited: false,
        employees: [
          Employees(
            position: "Manager",
            departmentName: "Sales",
            departmentId: 201,
            branchName: "Main Branch",
            branchId: 301,
            role: "Supervisor",
            canAddAttendance: true,
            canAddPlan: false,
            id: "E001",
            userName: "john_doe",
            name: "John Doe",
            mobileId: "M001",
          ),
        ],
        customer: Customer(
          id: "C001",
          name: "ABC Corp",
          workesAs: "Retailer",
          location: "Downtown",
          customerType: "Customer",
          coordinates: [],
        ),
      ),
      CustomerPlans(
        id: 102,
        note: "Inspect construction progress",
        visited: true,
        employees: [
          Employees(
            position: "Engineer",
            departmentName: "Construction",
            departmentId: 202,
            branchName: "North Branch",
            branchId: 302,
            role: "Field Engineer",
            canAddAttendance: false,
            canAddPlan: true,
            id: "E002",
            userName: "jane_smith",
            name: "Jane Smith",
            mobileId: "M002",
          ),
        ],
        customer: Customer(
          id: "C002",
          name: "XYZ Construction Site",
          workesAs: "Construction Site",
          location: "Uptown",
          customerType: "Site",
          coordinates: [],
        ),
      ),
      CustomerPlans(
        id: 103,
        note: "Annual client review",
        visited: false,
        employees: [
          Employees(
            position: "Account Manager",
            departmentName: "Client Relations",
            departmentId: 203,
            branchName: "East Branch",
            branchId: 303,
            role: "Account Manager",
            canAddAttendance: true,
            canAddPlan: true,
            id: "E003",
            userName: "alice_doe",
            name: "Alice Doe",
            mobileId: "M003",
          ),
        ],
        customer: Customer(
          id: "C003",
          name: "DEF Corporation",
          workesAs: "Wholesaler",
          location: "Midtown",
          customerType: "",
          coordinates: [],
        ),
      ),
    ],
  );
}
