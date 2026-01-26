import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

part 'department_state.dart';

class DepartmentCubit extends Cubit<DepartmentState> {
  final DepartmentRepo departmentRepo;
  DepartmentCubit(this.departmentRepo) : super(DepartmentInitial());
  TextEditingController addDepartmentController = TextEditingController();
  TextEditingController editDepartmentNameController = TextEditingController();

  Future<void> addDepartment() async {
    if (isClosed) return;
    emit(AddDepartmentLoading());
    try {
      await departmentRepo.addDepartment(
          departmentName: addDepartmentController.text.trim());
      if (isClosed) return;
      getAllDepartments();
      emit(AddDepartmentSuccess());
    } catch (e) {
      if (isClosed) return;
      emit(AddDepartmentError('there is an error, please try again!'));
    }
  }

  Future<void> getAllDepartments() async {
    if (isClosed) return;
    emit(GetDepartmentLoading());
    final result = await departmentRepo.getAllDepartments();

    result.fold(
      (error) {
        if (isClosed) return;
        emit(GetDepartmentError(error.message));
      },
      (departmentList) {
        if (isClosed) return;
        emit(GetDepartmentSuccess(departmentList));
      },
    );
  }

  Future<void> searchDepartment(String query) async {
    if (isClosed) return;
    emit(SearchDepartmentLoading());
    final result = await departmentRepo.searchDepartments(searchKey: query);
    if (isClosed) return;
    result.fold(
      (error) {
        emit(SearchDepartmentError(error.message));
      },
      (departmentList) {
        emit(SearchDepartmentSuccess(departmentList));
      },
    );
  }

  Future<void> deleteDepartment(int id) async {
    if (isClosed) return;
    emit(DeleteDepartmentLoading());
    final result = await departmentRepo.deleteDepartment(id: id);
    if (isClosed) return;
    result.fold(
      (error) {
        emit(DeleteDepartmentError(error.message));
      },
      (success) {
        getAllDepartments();
        emit(DeleteDepartmentSuccess());
      },
    );
  }

  Future<void> editDepartment(
    int id,
  ) async {
    if (isClosed) return;
    emit(EditDepartmentLoading());
    final result = await departmentRepo.editDepartment(
        id: id, departmentName: editDepartmentNameController.text.trim());
    if (isClosed) return;
    result.fold(
      (error) {
        emit(EditDepartmentError(error.message));
      },
      (success) {
        getAllDepartments();
        emit(EditDepartmentSuccess());
      },
    );
  }

  @override
  Future<void> close() {
    addDepartmentController.dispose();
    editDepartmentNameController.dispose();
    return super.close();
  }
}
