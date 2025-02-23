import 'package:absen_smkn1_punggelan/app/module/entity/attendance.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attendance.g.dart';

@JsonSerializable()
class Attendance {
  final int id;
  
  @JsonKey(name: 'date', fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime date;
  
  final String status;
  
  @JsonKey(name: 'check_in')
  final String? checkIn;
  
  @JsonKey(name: 'check_out')
  final String? checkOut;
  
  @JsonKey(name: 'check_in_location')
  final String? checkInLocation;
  
  @JsonKey(name: 'check_out_location')
  final String? checkOutLocation;
  
  @JsonKey(name: 'check_in_photo')
  final String? checkInPhoto;
  
  @JsonKey(name: 'check_out_photo')
  final String? checkOutPhoto;

  Attendance({
    required this.id,
    required this.date,
    required this.status,
    this.checkIn,
    this.checkOut,
    this.checkInLocation,
    this.checkOutLocation,
    this.checkInPhoto,
    this.checkOutPhoto,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) =>
      _$AttendanceFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceToJson(this);

  static DateTime _dateFromJson(String date) => DateTime.parse(date);
  static String _dateToJson(DateTime date) => date.toIso8601String();
}
