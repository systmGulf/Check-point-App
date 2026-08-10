
import 'package:freezed_annotation/freezed_annotation.dart';
part 'track_user_request_body.g.dart';
@JsonSerializable()
class TrackUserRequestBody {
  String? employeeId;
  List<Map<String, dynamic>>? coordinates;

  TrackUserRequestBody({this.employeeId, this.coordinates});
  Map<String, dynamic> toJson() => _$TrackUserRequestBodyToJson(this);
 
}