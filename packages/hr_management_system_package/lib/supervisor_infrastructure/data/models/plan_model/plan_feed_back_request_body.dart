import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_feed_back_request_body.g.dart';

@JsonSerializable()
class PlanFeedBackRequestBody {
  final String imageUrl;
  final String notes;
  final String status;
  final int customerPlanId;

  PlanFeedBackRequestBody({
    required this.imageUrl,
    required this.notes,
    required this.status,
   
    required this.customerPlanId,
  });
  
  Map<String, dynamic> toJson() => _$PlanFeedBackRequestBodyToJson(this);
}
