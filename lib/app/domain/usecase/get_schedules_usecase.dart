import 'package:absen_smkn1_punggelan/app/core/result/result.dart';
import 'package:absen_smkn1_punggelan/app/data/model/schedule.dart';
import 'package:absen_smkn1_punggelan/app/domain/repository/i_schedule_repository.dart';

class GetSchedulesUseCase {
  final IScheduleRepository _repository;

  GetSchedulesUseCase(this._repository);

  Future<Result<List<Schedule>>> call() async {
    return _repository.getSchedules();
  }
}
