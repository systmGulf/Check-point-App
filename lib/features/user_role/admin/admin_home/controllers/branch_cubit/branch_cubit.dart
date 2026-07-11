import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

part 'branch_state.dart';

class BranchCubit extends Cubit<BranchState> {
  BranchCubit({required this.branchesRepo}) : super(BranchInitial());

  final BranchesRepo branchesRepo;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<LocationFrameLatLng> locationFrame = [];

  void resetForm() {
    nameController.clear();
    locationController.clear();
    descriptionController.clear();
    locationFrame.clear();
  }

  Future<void> getBranches({required bool isLoading}) async {
    if (isLoading) emit(GetBranchLoading());
    final result = await branchesRepo.getAllBranches();
    result.fold((l) {
      if (isClosed) return;
      emit(GetBranchError(error: l.message));
    }, (r) {
      if (isClosed) return;
      emit(GetBranchSuccess(branches: r));
    });
  }

  Future<void> addBranch() async {
    emit(AddBranchLoading());
    final result = await branchesRepo.addCompanyBranch(
        addBranchRequestBody: AddBrachRequestBody(
            name: nameController.text,
            location: locationController.text,
            description: descriptionController.text,
            coordinates: locationFrame));

    result.fold((l) {
      if (isClosed) return;
      emit(AddBranchError(
        error: l.message,
      ));
    }, (r) async {
      if (isClosed) return;
      emit(AddBranchSuccess());
      await getBranches(isLoading: false);
    });
  }

  Future<void> editBranch({required int id}) async {
    emit(EditBranchLoading());
    final result = await branchesRepo.editBranch(
      id: id,
      addBranchRequestBody: AddBrachRequestBody(
        name: nameController.text,
        location: locationController.text,
        description: descriptionController.text,
        coordinates: locationFrame,
      ),
    );

    result.fold((l) {
      if (isClosed) return;
      emit(EditBranchError(error: l.message));
    }, (r) async {
      if (isClosed) return;
      emit(EditBranchSuccess());
      await getBranches(isLoading: false);
    });
  }

  Future<void> deleteBranch(int id) async {
    emit(DeleteBranchLoading());
    final result = await branchesRepo.deleteBranch(id: id);
    result.fold((l) {
      if (isClosed) return;
      emit(DeleteBranchError(
        error: l.message,
      ));
    }, (r) {
      if (isClosed) return;
      getBranches(isLoading: false);
      emit(DeleteBranchSuccess());
    });
  }

  @override
  Future<void> close() {
    nameController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
