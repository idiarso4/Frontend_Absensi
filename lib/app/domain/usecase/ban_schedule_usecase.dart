import 'package:absen_smkn1_punggelan/app/core/result/result.dart';
import 'package:absen_smkn1_punggelan/app/domain/repository/i_schedule_repository.dart';

class BanScheduleUseCase {
  final IScheduleRepository _repository;

  BanScheduleUseCase(this._repository);

  Future<Result<void>> call(String id) async {
    return _repository.banSchedule(id);
  }
}
