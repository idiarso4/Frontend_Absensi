// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      id: (json['id'] as num).toInt(),
      day: json['day'] as String,
      status: json['status'] as String,
      checkIn: json['check_in'] as String,
      checkOut: json['check_out'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'id': instance.id,
      'day': instance.day,
      'status': instance.status,
      'check_in': instance.checkIn,
      'check_out': instance.checkOut,
      'is_active': instance.isActive,
    };
