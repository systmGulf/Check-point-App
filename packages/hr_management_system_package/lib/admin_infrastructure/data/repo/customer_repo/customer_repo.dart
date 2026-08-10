import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../models/customers_model/add_customer_request_body.dart';
import '../../models/customers_model/get_customer_model.dart';

abstract class CustomerRepo {
  // Add new customer
  Future<Either<Failure, void>> addCustomer(
    AddOrEditCustomerRequestBody departmentValue,
  );
  // Get all Customers By Type (Customer & Site)
  Future<Either<Failure, CustomersPage>> getCustomersByType({
    required String type,
  });
  // delete customer
  Future<Either<Failure, void>> deleteCustomer({
    required String id,
  });

  // edit customer
  Future<Either<Failure, void>> editCustomer(
    AddOrEditCustomerRequestBody departmentValue, {
    required String id,
  });
}
