import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../models/customers_model/get_customer_by_id_model.dart';
import '../../models/plan_model/customer_plan_model.dart';
import '../../models/plan_model/get_plan_by_id_model.dart';
import '../../models/plan_model/get_plan_model.dart';
import '../../models/plan_model/set_customer_plan_request_body.dart';

abstract class SupervisorPlanRepo {
  // Supervisor get Customer plans in His Department
  Future<Either<Failure, List<CustomerPlanModel>>> getCustomerPlans();
  // Supervisor set Customer plans in His Department
  Future<Either<Failure, void>> setPlanByDate(
      SetPlanByDateRequestBody setPlanByDateRequestBody);
  // Supervisor get Plan by Id

  Future<Either<Failure, PlanDetails>> getPlanById({required int id});
  // Supervisor delete Plan by Id
  Future<Either<Failure, void>> deletePlanById({required int id});
  // Supervisor set Customer Plan
  Future<Either<Failure, void>> setCustomerPlan(
      SetCustomerPlanRequestBody setCustomerPlanRequestBody);
  // Supervisor set Sub Plan
  Future<Either<Failure, void>> setSubPlan(
      {required SetSubPlansRequestBody setSubPlansRequestBody});
  // Supervisor delete Sub Plan
  Future<Either<Failure, void>> deleteSubPlanById({required int id});
  Future<Either<Failure, void>> deleteSomeEmployeesFromPlan(
      {required int planId, required String employeeIds});

  //  Supervisor get Plan by Department
  Future<Either<Failure, PlansPage>> getPlanByDepartmentId();
  // Supervisor get Customer by Id
  Future<Either<Failure, GetCustomerByIdModel>> getCustomerById(
      {required String customerId});
}
