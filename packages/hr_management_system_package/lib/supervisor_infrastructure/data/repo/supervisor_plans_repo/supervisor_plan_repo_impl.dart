import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/networking/api_constant.dart';
import '../../../../core/networking/api_service.dart';
import '../../models/customers_model/get_customer_by_id_model.dart';
import '../../models/plan_model/customer_plan_model.dart';
import '../../models/plan_model/get_plan_by_id_model.dart';
import '../../models/plan_model/get_plan_model.dart';
import '../../models/plan_model/remove_employees_from_plan_request_body.dart';
import '../../models/plan_model/set_customer_plan_request_body.dart';
import 'supervisor_plan_repo.dart';

class SupervisorPlanRepoImpl implements SupervisorPlanRepo {
  final ApiService apiService;

  SupervisorPlanRepoImpl({
    required this.apiService,
  });

  @override
  // get customer plans
  Future<Either<Failure, List<CustomerPlanModel>>> getCustomerPlans() async {
    try {
      final result = await apiService.get(
          endPoint:
              "${ApiConstant.customerplan}/departmentId/${ApiConstant.departmentId}");
      if (result[ApiConstant.successApiKey] == true) {
        return Right((result['value'] as List)
            .map((e) => CustomerPlanModel.fromJson(e))
            .toList());
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // set customer plan
  Future<Either<Failure, void>> setPlanByDate(
      SetPlanByDateRequestBody setPlanByDateRequestBody) async {
    try {
      final result = await apiService.post(
          endPoint: ApiConstant.plan, body: setPlanByDateRequestBody.toJson());
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
  // get plan by id
  Future<Either<Failure, PlanDetails>> getPlanById(
      {required int id}) async {
    try {
      final result = await apiService.get(endPoint: "${ApiConstant.plan}/$id");
      if (result[ApiConstant.successApiKey] == true) {
        final response = GetPlanById.fromJson(result);
        return Right(response.planDetailsOrEmpty);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // delete plan
  Future<Either<Failure, void>> deletePlanById({required int id}) async {
    try {
      final result =
          await apiService.delete(endPoint: "${ApiConstant.plan}/$id");
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
  // set customer plan
  Future<Either<Failure, void>> setCustomerPlan(
      SetCustomerPlanRequestBody setCustomerPlanRequestBody) async {
    try {
      final result = await apiService.post(
          endPoint: ApiConstant.customerplan,
          body: setCustomerPlanRequestBody.toJson());
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
  // set sub plan
  Future<Either<Failure, void>> setSubPlan(
      {required SetSubPlansRequestBody setSubPlansRequestBody}) async {
    try {
      final result = await apiService.post(
          endPoint: "${ApiConstant.plan}/${ApiConstant.customerplan}",
          body: setSubPlansRequestBody.toJson());
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
  // delete sub plan
  Future<Either<Failure, void>> deleteSubPlanById({required int id}) async {
    try {
      final result = await apiService.delete(
          endPoint: "${ApiConstant.plan}/${ApiConstant.customerplan}?id=$id");
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
  Future<Either<Failure, PlansPage>> getPlanByDepartmentId() async {
    try {
      final result = await apiService.get(
          endPoint:
              "${ApiConstant.plan}/department/${ApiConstant.departmentId}");
      if (result[ApiConstant.successApiKey] == true) {
        final response = PlanModel.fromJson(result);
        return Right(response.plansPageOrEmpty);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // get customer by id
  Future<Either<Failure, GetCustomerByIdModel>> getCustomerById(
      {required String customerId}) async {
    try {
      final result = await apiService.get(
          endPoint: "${ApiConstant.addCustomer}/$customerId");
      if (result[ApiConstant.successApiKey] == true) {
        return Right(GetCustomerByIdModel.fromJson(result));
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteSomeEmployeesFromPlan(
      {required int planId, required String employeeIds}) async {
    try {
      final requestBody = RemoveEmployeesFromPlanRequestBody(
        employeeIds: employeeIds,
        customerPlanId: planId,
      );
      final result = await apiService.post(
          endPoint: "${ApiConstant.employee}/removeAssignCustomerPlan",
          body: requestBody.toJson());
      if (result[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
