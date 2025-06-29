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
    emit(AddDepartmentLoading());
    try {
      await departmentRepo.addDepartment(
          departmentName: addDepartmentController.text.trim());
      getAllDepartments();
      emit(AddDepartmentSuccess());
    } catch (e) {
      emit(AddDepartmentError('there is an error, please try again!'));
    }
  }

  Future<void> getAllDepartments() async {
    emit(GetDepartmentLoading());
    final result = await departmentRepo.getAllDepartments();
    result.fold(
      (error) {
        emit(GetDepartmentError(error.message));
      },
      (departmentList) {
        emit(GetDepartmentSuccess(departmentList));
      },
    );
  }

  Future<void> searchDepartment(String query) async {
    emit(SearchDepartmentLoading());
    final result = await departmentRepo.searchDepartments(searchKey: query);
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
    emit(DeleteDepartmentLoading());
    final result = await departmentRepo.deleteDepartment(id: id);
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
    emit(EditDepartmentLoading());
    final result = await departmentRepo.editDepartment(
        id: id, departmentName: editDepartmentNameController.text.trim());
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
