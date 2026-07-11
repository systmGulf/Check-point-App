import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import '../../../../../../core/common/excel_export_service.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final AdminManageEmployeeRepo adminManageEmployeeRepo;
  EmployeeCubit({required this.adminManageEmployeeRepo}) : super(EmployeeInitial());

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

  int? totalEmployeesCount;
  int? totalAccountRequestsCount;

  Future<void> getAllEmployees({
    int pageNumber = 0,
    required int itemCount,
  }) async {
    if (pageNumber == 0) {
      emit(GetAllEmployeesLoading());
    } else {
      emit(GetAllEmployeesPaginationLoading());
    }
    final result = await adminManageEmployeeRepo.getAllEmployees(
        pageNumber: pageNumber, itemCount: itemCount);
    result.fold(
      (error) {
        if (isClosed) return;
        if (pageNumber == 0) {
          emit(GetAllEmployeesFailure(error: error.message));
        } else {
          emit(GetAllEmployeesPaginationFailure(error: error.message));
        }
      },
      (allEmployeesList) {
        if (isClosed) return;
        totalEmployeesCount = allEmployeesList.totalCount;
        emit(GetAllEmployeesSuccess(value: allEmployeesList));
      },
    );
  }

  Future<GetAllEmployeesValue?> fetchEmployeesPage({
    required int pageKey,
    required int pageSize,
  }) async {
    final result = await adminManageEmployeeRepo.getAllEmployees(
      pageNumber: pageKey,
      itemCount: pageSize,
    );
    return result.fold(
      (error) {
        emit(GetAllEmployeesPaginationFailure(error: error.message));
        return null;
      },
      (allEmployeesList) {
        totalEmployeesCount = allEmployeesList.totalCount;
        return allEmployeesList;
      },
    );
  }
  // Search employee

  Future<void> searchEmployee({required String name}) async {
    emit(SearchEmployeeLoading());
    final result =
        await adminManageEmployeeRepo.searchEmployees(searchKey: name);
    result.fold(
      (error) {
        if (!isClosed) emit(SearchEmployeeFailure(error: error.message));
      },
      (employeeList) {
        if (!isClosed) emit(SearchEmployeeSuccess(employeeList: employeeList));
      },
    );
  }

  Future<void> getEmployeeByDepartment({required int departmentId}) async {
    emit(GetEmployeeByDepartmentLoading());
    final result = await adminManageEmployeeRepo.getEmployeesInDepartment(
        pageKey: 0, pageSize: 10, id: departmentId);
    await result.fold(
      (error) {
        if (!isClosed) emit(GetEmployeeByDepartmentError(error.message));
      },
      (employeeList) async {
        if (!isClosed) emit(GetEmployeeByDepartmentSuccess(employeeList));
      },
    );
  }

  Future<GetEmployeesInDepartmentValue?> fetchEmployeesByDepartmentPage({
    required int departmentId,
    required int pageKey,
    required int pageSize,
  }) async {
    final result = await adminManageEmployeeRepo.getEmployeesInDepartment(
      id: departmentId,
      pageKey: pageKey,
      pageSize: pageSize,
    );
    return result.fold(
      (error) => null,
      (employeeList) => employeeList,
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
      (l) {
        if (!isClosed) emit(AddEmployeeFailure(error: l.message));
      },
      (r) async {
        await getAllEmployees(pageNumber: 0, itemCount: 10);
        if (!isClosed) emit(AddEmployeeSuccess());
      },
    );
  }

  Future<void> getAddAccountRequests() async {
    emit(GetAddAccountRequestsLoading());
    final result = await adminManageEmployeeRepo.getAddAccountRequestsForAdmin(
      pageNumber: 0,
      itemCount: 10,
    );
    result.fold(
      (l) {
        if (!isClosed) emit(GetAddAccountRequestsFailure(error: l.message));
      },
      (r) {
        if (isClosed) return;
        totalAccountRequestsCount = r.totalCount;
        emit(GetAddAccountRequestsSuccess(value: r));
      },
    );
  }

  void clearAccountRequestsCache() {
    totalAccountRequestsCount = null;
  }

  Future<List<AddAccountRequestData>?> fetchAccountRequestsPage({
    required int pageKey,
    required int pageSize,
  }) async {
    final result = await adminManageEmployeeRepo.getAddAccountRequestsForAdmin(
      pageNumber: pageKey,
      itemCount: pageSize,
    );
    return result.fold(
      (error) {
        emit(GetAccountRequestsPaginationFailure(error: error.message));
        return null;
      },
      (value) {
        totalAccountRequestsCount = value.totalCount;
        return value.data ?? [];
      },
    );
  }

  Future<void> deleteAddAccountRequest({required int id}) async {
    emit(DeleteAddAccountRequestLoading());
    final result =
        await adminManageEmployeeRepo.deleteAddAccountRequestsForAdmin(id: id);
    result.fold(
      (l) {
        if (!isClosed) emit(DeleteAddAccountRequestFailure(error: l.message));
      },
      (r) async {
        await getAddAccountRequests();
        if (!isClosed) emit(DeleteAddAccountRequestSuccess());
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
      if (!isClosed) emit(AttendAntherEmployeePermissionFailure(l.message));
    }, (r) {
      if (!isClosed) emit(AttendAntherEmployeePermissionSuccess());
    });
  }

  Future<void> setPlanPermission(
      {required String employeeId, required bool permission}) async {
    emit(SetPlanPermissionLoading());
    final result = await adminManageEmployeeRepo.setPlanPermission(
        supervisorId: employeeId, permission: permission);
    result.fold((l) {
      if (!isClosed) emit(SetPlanPermissionFailure(l.message));
    }, (r) {
      if (!isClosed) emit(SetPlanPermissionSuccess());
    });
  }

  Future<void> exportEmployeesToExcel() async {
    emit(ExportEmployeesLoading());
    try {
      final result = await adminManageEmployeeRepo.getAllEmployees(
        pageNumber: 0,
        itemCount: 1000,
      );
      result.fold(
        (error) {
          if (!isClosed) emit(ExportEmployeesFailure(error: error.message));
        },
        (employeesPage) async {
          final data = employeesPage.data ?? [];
          if (data.isEmpty) {
            if (!isClosed) emit(ExportEmployeesFailure(error: 'No employees to export'));
            return;
          }
          final excelService = ExcelExportService();
          final headers = [
            'ID',
            'Name',
            'Username',
            'Position',
            'Mobile ID',
            'Role',
            'Branch',
            'Department',
            'Shift'
          ];
          final rows = data.map((e) => [
            e.id ?? '',
            e.name ?? '',
            e.userName ?? '',
            e.position ?? '',
            e.mobileId ?? '',
            e.role ?? '',
            e.branchName ?? '',
            e.departmentName ?? '',
            e.shiftName ?? '',
          ]).toList();
          
          final bytes = excelService.generateExcel(
            sheetName: 'Employees',
            headers: headers,
            data: rows,
          );
          if (bytes == null) {
            if (!isClosed) emit(ExportEmployeesFailure(error: 'Failed to generate Excel'));
            return;
          }
          await excelService.shareExcel(
            fileBytes: bytes,
            fileName: 'Employees_List.xlsx',
            message: 'Here is the employee list.',
          );
          if (!isClosed) emit(ExportEmployeesSuccess());
        },
      );
    } catch (e) {
      if (!isClosed) emit(ExportEmployeesFailure(error: e.toString()));
    }
  }
}
