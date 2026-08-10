import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/admin_infrastructure/admin_data.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final AdminManageEmployeeRepo adminManageEmployeeRepo;
  EmployeeCubit(this.adminManageEmployeeRepo) : super(EmployeeInitial());

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController mobileIdController = TextEditingController();
  int departmentId = 00;
  int branchId = 00;
  List<String> deviceToken = [];
  String role = 'Employee';
  TextEditingController editNameController = TextEditingController();
  TextEditingController editUsernameController = TextEditingController();
  TextEditingController editPasswordController = TextEditingController();
  TextEditingController editPositionController = TextEditingController();
  TextEditingController editMobileIdController = TextEditingController();

  Future<void> getAllEmployees(
      {int pageNumber = 0, required int itemCount}) async {
    if (pageNumber == 0) {
      emit(GetAllEmployeesLoading());
    } else {
      emit(GetAllEmployeesPaginationLoading());
    }
    final result = await adminManageEmployeeRepo.getAllEmployees(
        pageNumber: pageNumber, itemCount: itemCount);
    result.fold(
      (error) {
        if (pageNumber == 0) {
          emit(GetAllEmployeesFailure(error: error.message));
        } else {
          emit(GetAllEmployeesPaginationFailure(error: error.message));
        }
      },
      (allEmployeesList) {
        emit(GetAllEmployeesSuccess(value: allEmployeesList));
      },
    );
  }

  Future<void> getEmployeeByDepartment({required int departmentId, int pageKey = 1, int pageSize = 100}) async {
    emit(GetEmployeeByDepartmentLoading());
    final result = await adminManageEmployeeRepo.getEmployeesInDepartment(
        id: departmentId, pageKey: pageKey, pageSize: pageSize);
    await result.fold(
      (error) {
        emit(GetEmployeeByDepartmentError(error.message));
      },
      (employeeList) async {
        emit(GetEmployeeByDepartmentSuccess(employeeList));
      },
    );
  }

  Future<void> deleteUserAccount({required String userId}) async {
    emit(DeleteUserAccountLoading());
    try {
      await adminManageEmployeeRepo.deleteEmployeeAccount(userId: userId);
      await getAllEmployees(pageNumber: 0, itemCount: 10);
      emit(DeleteUserAccountSuccess());
    } catch (e) {
      emit(DeleteUserAccountFailure(error: e.toString()));
    }
  }

  Future<void> addEmployee({required String role}) async {
    emit(AddEmployeeLoading());
    final result = await adminManageEmployeeRepo.addEmployee(
      AddEmployeeRequestBody(
        deviceToken,
        departmentId: departmentId,
        branchId: branchId,
        name: nameController.text,
        username: usernameController.text,
        password: passwordController.text,
        position: positionController.text,
        mobileId: mobileIdController.text,
        role: role,
      ),
    );

    result.fold(
      (l) => emit(AddEmployeeFailure(error: l.message)),
      (r) async {
        await getAllEmployees(pageNumber: 0, itemCount: 10);
        emit(AddEmployeeSuccess());
      },
    );
  }

  Future<void> getAddAccountRequests({int pageNumber = 0, int itemCount = 100}) async {
    emit(GetAddAccountRequestsLoading());
    final result =
        await adminManageEmployeeRepo.getAddAccountRequestsForAdmin(pageNumber: pageNumber, itemCount: itemCount);
    result.fold(
      (l) => emit(GetAddAccountRequestsFailure(error: l.message)),
      (r) => emit(GetAddAccountRequestsSuccess(value: r)),
    );
  }

  Future<void> deleteAddAccountRequest({required int id}) async {
    emit(DeleteAddAccountRequestLoading());
    final result =
        await adminManageEmployeeRepo.deleteAddAccountRequestsForAdmin(id: id);
    result.fold(
      (l) => emit(DeleteAddAccountRequestFailure(error: l.message)),
      (r) async {
        await getAddAccountRequests();
        emit(DeleteAddAccountRequestSuccess());
      },
    );
  }

  Future<void> editEmployee({required String id}) async {
    emit(EditEmployeeLoading());
    if (departmentId == 00) {
      emit(EditEmployeeFailure(error: "Please Select Department"));
    } else if (branchId == 00) {
      emit(EditEmployeeFailure(error: "Please Select Branch"));
    }
    try {
      var result = await adminManageEmployeeRepo.editEmployee(
        EditEmployeeRequestBody(
          branchId: branchId,
          name: editNameController.text,
          userName: editUsernameController.text,
          password: editPasswordController.text,
          position: editPositionController.text,
          mobileId: editMobileIdController.text,
          role: role,
          departmentId: departmentId,
        ),
        id: id,
      );

      result.fold(
        (l) => emit(EditEmployeeFailure(error: l.message)),
        (r) async {
          await getAllEmployees(pageNumber: 0, itemCount: 10);
          emit(EditEmployeeSuccess());
        },
      );
    } catch (e) {
      emit(EditEmployeeFailure(error: e.toString()));
    }
  }

  Future<void> attendAntherEmployeePermission(
      {required String employeeId, required bool permission}) async {
    emit(AttendAntherEmployeePermissionLoading());
    final result = await adminManageEmployeeRepo.attendAntherUserPermission(
        supervisorId: employeeId, permission: permission);
    result.fold((l) {
      emit(AttendAntherEmployeePermissionFailure(l.message));
    }, (r) {
      emit(AttendAntherEmployeePermissionSuccess());
    });
  }

  Future<void> setPlanPermission(
      {required String employeeId, required bool permission}) async {
    emit(SetPlanPermissionLoading());
    final result = await adminManageEmployeeRepo.setPlanPermission(
        supervisorId: employeeId, permission: permission);
    result.fold((l) {
      emit(SetPlanPermissionFailure(l.message));
    }, (r) {
      emit(SetPlanPermissionSuccess());
    });
  }
}
