import 'package:dio/dio.dart';
import 'package:absen_smkn1_punggelan/app/core/result/result.dart';
import 'package:absen_smkn1_punggelan/app/data/model/schedule.dart';
import 'package:absen_smkn1_punggelan/app/domain/repository/i_schedule_repository.dart';
import 'package:absen_smkn1_punggelan/core/constant/api_constants.dart';

class ScheduleRepository implements IScheduleRepository {
  final Dio _dio;

  ScheduleRepository({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<Result<List<Schedule>>> getSchedules() async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}/api/schedules');
      
      final List<dynamic> data = response.data['data'];
      final schedules = data.map((json) => Schedule.fromJson(json)).toList();
      
      return DataSuccess(schedules);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<Result<void>> banSchedule(String id) async {
    try {
      await _dio.post('${ApiConstants.baseUrl}/api/schedule/banned/$id');
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
