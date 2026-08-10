// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_police_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddPoliceRequestBody _$AddPoliceRequestBodyFromJson(
        Map<String, dynamic> json) =>
    AddPoliceRequestBody(
      month: json['month'] as String,
      year: json['year'] as String,
      clockInTime: json['clockInTime'] as String,
      clockOutTime: json['clockOutTime'] as String,
      area: json['area'] as String,
      shiftId: json['shiftId'] as String,
    );

Map<String, dynamic> _$AddPoliceRequestBodyToJson(
        AddPoliceRequestBody instance) =>
    <String, dynamic>{
      'month': instance.month,
      'year': instance.year,
      'clockInTime': instance.clockInTime,
      'clockOutTime': instance.clockOutTime,
      'area': instance.area,
      'shiftId': instance.shiftId,
    };
