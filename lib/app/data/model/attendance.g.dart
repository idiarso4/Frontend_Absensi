// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attendance _$AttendanceFromJson(Map<String, dynamic> json) => Attendance(
      id: (json['id'] as num).toInt(),
      date: Attendance._dateFromJson(json['date'] as String),
      status: json['status'] as String,
      checkIn: json['check_in'] as String?,
      checkOut: json['check_out'] as String?,
      checkInLocation: json['check_in_location'] as String?,
      checkOutLocation: json['check_out_location'] as String?,
      checkInPhoto: json['check_in_photo'] as String?,
      checkOutPhoto: json['check_out_photo'] as String?,
    );

Map<String, dynamic> _$AttendanceToJson(Attendance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': Attendance._dateToJson(instance.date),
      'status': instance.status,
      'check_in': instance.checkIn,
      'check_out': instance.checkOut,
      'check_in_location': instance.checkInLocation,
      'check_out_location': instance.checkOutLocation,
      'check_in_photo': instance.checkInPhoto,
      'check_out_photo': instance.checkOutPhoto,
    };
