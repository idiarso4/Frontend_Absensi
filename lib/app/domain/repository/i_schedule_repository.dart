import 'package:absen_smkn1_punggelan/app/core/result/result.dart';
import 'package:absen_smkn1_punggelan/app/data/model/schedule.dart';

abstract class IScheduleRepository {
  Future<Result<List<Schedule>>> getSchedules();
  Future<Result<void>> banSchedule(String id);
}
