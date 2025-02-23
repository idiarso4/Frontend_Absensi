import 'package:absen_smkn1_punggelan/app/core/result/result.dart';
import 'package:absen_smkn1_punggelan/app/data/model/attendance.dart';

abstract class IAttendanceRepository {
  Future<Result<Attendance>> getTodayAttendance();
  Future<Result<List<Attendance>>> getMonthAttendance();
}
