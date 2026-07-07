import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/enums/customer_type.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final CustomerRepo customerRepo;
  CustomerCubit({required this.customerRepo}) : super(CustomerInitial());
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController workedAsController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  TextEditingController editNameController = TextEditingController();
  TextEditingController editWorkedAsController = TextEditingController();
  TextEditingController editLocationController = TextEditingController();
  List<CustomerLocation> customersLocation = [];
  Future<void> addCustomer({required CustomerType customerType}) async {
    emit(AddCustomerLoading());
    final result = await customerRepo.addCustomer(AddOrEditCustomerRequestBody(
        customerType: customerType.name,
        coordinates: customersLocation,
        name: nameController.text,
        workesAs: workedAsController.text,
        location: locationController.text));

    result.fold((l) {
      emit(AddCustomerError(error: l.message));
    }, (r) {
      nameController.clear();
      workedAsController.clear();
      locationController.clear();
      emit(AddCustomerSuccess());
      getCustomersByType(customerType: customerType, isLoading: false);
    });
  }

  Future<void> editCustomer(
      {required String id, required CustomerType customerType}) async {
    emit(EditCustomerLoading());
    final result = await customerRepo.editCustomer(
      id: id,
      AddOrEditCustomerRequestBody(
        customerType: customerType.name,
        coordinates: customersLocation,
        name: editNameController.text,
        workesAs: editWorkedAsController.text,
        location: editLocationController.text,
      ),
    );

    result.fold((l) {
      emit(EditCustomerError(error: l.message));
    }, (r) {
      nameController.clear();
      workedAsController.clear();
      locationController.clear();
      emit(EditCustomerSuccess());
      getCustomersByType(customerType: customerType, isLoading: false);
    });
  }

  Future<void> deleteCustomer(
      {required String id, required CustomerType customerType}) async {
    emit(DeleteCustomerLoading());
    try {
      final result = await customerRepo.deleteCustomer(id: id);
      result.fold(
        (l) => emit(
          DeleteCustomerError(
            error: l.toString(),
          ),
        ),
        (r) {
          getCustomersByType(customerType: customerType, isLoading: false);
          emit(DeleteCustomerSuccess());
        },
      );
    } on Exception catch (e) {
      emit(
        DeleteCustomerError(
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> getCustomersByType(
      {required CustomerType customerType, required bool isLoading}) async {
    if (isLoading) emit(GetAllCustomersLoading());
    final result =
        await customerRepo.getCustomersByType(type: customerType.name);
    result.fold(
      (l) {
        if (isClosed) return;
        emit(
          GetAllCustomersError(
            error: l.message,
          ),
        );
      },
      (r) async {
        if (isClosed) return;
        emit(
          GetAllCustomersSuccess(customers: r),
        );
      },
    );
  }

  Future<CustomerValue?> fetchCustomersPage({
    required CustomerType customerType,
    required int pageKey,
    required int pageSize,
  }) async {
    final result = await customerRepo.getCustomersByType(
      type: customerType.name,
    );
    return result.fold(
      (error) {
        emit(GetAllCustomersError(error: error.message));
        return null;
      },
      (customers) {
        return customers;
      },
    );
  }
}
