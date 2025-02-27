import 'package:absen_smkn1_punggelan/app/module/entity/attendance.dart';
import 'package:absen_smkn1_punggelan/app/module/repository/attendance_repository.dart';
import 'package:absen_smkn1_punggelan/core/network/data_state.dart';
import 'package:absen_smkn1_punggelan/core/use_case/app_use_case.dart';

class AttendanceSendUseCase
    extends AppUseCase<Future<DataState>, AttendanceParamEntity> {
  final AttendanceRepository _attendanceRepository;

  AttendanceSendUseCase(this._attendanceRepository);

  @override
  Future<DataState> call({AttendanceParamEntity? param}) {
    return _attendanceRepository.sendAttendance(param!);
  }
}
