import 'package:absen_smkn1_punggelan/app/core/result/result.dart';
import 'package:absen_smkn1_punggelan/app/data/model/attendance.dart';
import 'package:absen_smkn1_punggelan/app/domain/repository/i_attendance_repository.dart';

class GetTodayAttendanceUseCase {
  final IAttendanceRepository _repository;

  GetTodayAttendanceUseCase(this._repository);

  Future<Result<Attendance>> call() async {
    return _repository.getTodayAttendance();
  }
}
