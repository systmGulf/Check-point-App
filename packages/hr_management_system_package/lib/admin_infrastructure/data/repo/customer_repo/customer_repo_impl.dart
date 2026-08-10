import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/networking/api_constant.dart';
import '../../../../core/networking/api_service.dart';
import '../../models/customers_model/add_customer_request_body.dart';
import '../../models/customers_model/get_customer_model.dart';
import 'customer_repo.dart';

class CustomerRepoImpl implements CustomerRepo {
  final ApiService apiService;

  CustomerRepoImpl({
    required this.apiService,
  });

  @override
  // Add Customer
  Future<Either<Failure, void>> addCustomer(
      AddOrEditCustomerRequestBody departmentValue) async {
    try {
      final result = await apiService.post(
          endPoint: ApiConstant.addCustomer, body: departmentValue.toJson());
      if (result[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Delete Customer
  Future<Either<Failure, void>> deleteCustomer({required String id}) async {
    try {
      final result = await apiService.delete(
          endPoint: "${ApiConstant.addCustomer}?id=$id");
      if (result[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Edit Customer
  Future<Either<Failure, void>> editCustomer(
      AddOrEditCustomerRequestBody departmentValue,
      {required String id}) async {
    try {
      final result = await apiService.put(
          endPoint: "${ApiConstant.addCustomer}/$id",
          body: departmentValue.toJson());
      if (result[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Get Customer by Type (Customer & Site)
  Future<Either<Failure, CustomersPage>> getCustomersByType(
      {required String type}) async {
    try {
      final result = await apiService.get(
          endPoint: "${ApiConstant.addCustomer}/customerType/$type");
      if (result[ApiConstant.successApiKey] == true) {
        final response = CustomerModel.fromJson(result);
        return Right(response.customersPageOrEmpty);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
