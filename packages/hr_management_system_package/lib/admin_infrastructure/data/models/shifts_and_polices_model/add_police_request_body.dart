import 'package:freezed_annotation/freezed_annotation.dart';
part 'add_police_request_body.g.dart';
@JsonSerializable()
class AddPoliceRequestBody {
  final String month;
  final String year;
  final String clockInTime;
  final String clockOutTime;
  final String area;
  final String shiftId;

  AddPoliceRequestBody(
      {required this.month,
      required this.year,
      required this.clockInTime,
      required this.clockOutTime,
      required this.area,
      required this.shiftId});
      Map<String, dynamic> toJson() => _$AddPoliceRequestBodyToJson(this);
}
