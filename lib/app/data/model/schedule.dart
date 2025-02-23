import 'package:json_annotation/json_annotation.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule {
  final int id;
  final String day;
  final String status;
  
  @JsonKey(name: 'check_in')
  final String checkIn;
  
  @JsonKey(name: 'check_out')
  final String checkOut;
  
  @JsonKey(name: 'is_active')
  final bool isActive;

  Schedule({
    required this.id,
    required this.day,
    required this.status,
    required this.checkIn,
    required this.checkOut,
    this.isActive = true,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}
