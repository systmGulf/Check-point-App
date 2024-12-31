import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/admin/data/models/branches/add_branch_request_body.dart';
import 'package:hr_management_system_package/admin/data/models/branches/get_branches_models.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

part 'branch_state.dart';

class BranchCubit extends Cubit<BranchState> {
  final BranchesRepo branchesRepo;
  BranchCubit(this.branchesRepo) : super(BranchInitial());
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<LocationFrameLatLng> locationFrame = [];

  Future<void> getBranches({required bool isLoading}) async {
    if (isLoading) emit(GetBranchLoading());
    final result = await branchesRepo.getAllBranches();
    result.fold((l) {
      emit(GetBranchError(error: l.message));
    }, (r) {
      emit(GetBranchSuccess(branches: r));
    });
  }

  Future<void> addBranch() async {
    emit(AddBranchLoading());
    final result = await branchesRepo.addCompanyBranch(
        AddBrachRequestBody: AddBrachRequestBody(
            name: nameController.text,
            location: locationController.text,
            description: descriptionController.text,
            coordinates: locationFrame));

    result.fold((l) {
      emit(AddBranchError(
        error: l.message,
      ));
    }, (r) async {
      emit(AddBranchSuccess());
      await getBranches(isLoading: false);
    });
  }

  Future<void> deleteBranch(int id) async {
    emit(DeleteBranchLoading());
    final result = await branchesRepo.deleteBranch(id: id);
    result.fold((l) {
      emit(DeleteBranchError(
        error: l.message,
      ));
    }, (r) {
      getBranches(isLoading: false);
      emit(DeleteBranchSuccess());
    });
  }
}
