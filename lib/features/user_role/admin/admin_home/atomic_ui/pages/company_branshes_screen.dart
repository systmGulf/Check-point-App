import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controllers/branch_cubit/branch_cubit.dart';
import '../organism/company_branch_bloc_builder.dart';
import '../organism/company_branch_bottom_sheet.dart';

class CompanyBranchesScreen extends StatefulWidget {
  const CompanyBranchesScreen({super.key});

  @override
  State<CompanyBranchesScreen> createState() => _CompanyBranchesScreenState();
}

class _CompanyBranchesScreenState extends State<CompanyBranchesScreen> {
  Set<Polygon> polygons = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              builder: (BuildContext cnx) {
                return BlocProvider.value(
                  value: context.read<BranchCubit>(),
                  child: const AddBranchBottomSheet(),
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
        body: const Column(
          children: [
            Expanded(
              child: CompanyBranchesBlocBuilder(),
            ),
          ],
        ));
  }
}
