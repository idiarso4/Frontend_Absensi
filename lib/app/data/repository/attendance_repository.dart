import 'package:dio/dio.dart';
import 'package:absen_smkn1_punggelan/app/core/result/result.dart';
import 'package:absen_smkn1_punggelan/app/data/model/attendance.dart';
import 'package:absen_smkn1_punggelan/app/domain/repository/i_attendance_repository.dart';
import 'package:absen_smkn1_punggelan/core/constant/api_constants.dart';

class AttendanceRepository implements IAttendanceRepository {
  final Dio _dio;

  AttendanceRepository({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<Result<Attendance>> getTodayAttendance() async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}/api/attendance/today');
      final data = response.data['data'];
      final attendance = Attendance.fromJson(data);
      return DataSuccess(attendance);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<Result<List<Attendance>>> getMonthAttendance() async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}/api/attendance/month');
      final List<dynamic> data = response.data['data'];
      final attendances = data.map((json) => Attendance.fromJson(json)).toList();
      return DataSuccess(attendances);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
