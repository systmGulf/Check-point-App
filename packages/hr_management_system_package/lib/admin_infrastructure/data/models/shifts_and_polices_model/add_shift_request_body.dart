import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_shift_request_body.g.dart';

@JsonSerializable()
class AddShiftRequestBody {
  final String name;

  const AddShiftRequestBody({required this.name});

  factory AddShiftRequestBody.fromJson(Map<String, dynamic> json) =>
      _$AddShiftRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AddShiftRequestBodyToJson(this);
}
