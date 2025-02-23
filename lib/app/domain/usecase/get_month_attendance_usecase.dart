import 'package:absen_smkn1_punggelan/app/core/result/result.dart';
import 'package:absen_smkn1_punggelan/app/data/model/attendance.dart';
import 'package:absen_smkn1_punggelan/app/domain/repository/i_attendance_repository.dart';

class GetMonthAttendanceUseCase {
  final IAttendanceRepository _repository;

  GetMonthAttendanceUseCase(this._repository);

  Future<Result<List<Attendance>>> call() async {
    return _repository.getMonthAttendance();
  }
}
