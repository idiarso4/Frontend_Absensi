import 'package:get_it/get_it.dart';
import 'package:absen_smkn1_punggelan/app/data/repository/auth_repository.dart';
import 'package:absen_smkn1_punggelan/app/data/repository/schedule_repository.dart';
import 'package:absen_smkn1_punggelan/app/data/repository/attendance_repository.dart';
import 'package:absen_smkn1_punggelan/app/domain/repository/i_auth_repository.dart';
import 'package:absen_smkn1_punggelan/app/domain/repository/i_schedule_repository.dart';
import 'package:absen_smkn1_punggelan/app/domain/repository/i_attendance_repository.dart';
import 'package:absen_smkn1_punggelan/app/domain/usecase/auth_login_usecase.dart';
import 'package:absen_smkn1_punggelan/app/domain/usecase/get_schedules_usecase.dart';
import 'package:absen_smkn1_punggelan/app/domain/usecase/ban_schedule_usecase.dart';
import 'package:absen_smkn1_punggelan/app/domain/usecase/get_today_attendance_usecase.dart';
import 'package:absen_smkn1_punggelan/app/domain/usecase/get_month_attendance_usecase.dart';
import 'package:absen_smkn1_punggelan/app/presentation/login/login_notifier.dart';
import 'package:absen_smkn1_punggelan/app/presentation/attendance/schedule_notifier.dart';
import 'package:absen_smkn1_punggelan/app/presentation/home/home_notifier.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  // Repository
  getIt.registerLazySingleton<IAuthRepository>(() => AuthRepository());
  getIt.registerLazySingleton<IScheduleRepository>(() => ScheduleRepository());
  getIt.registerLazySingleton<IAttendanceRepository>(() => AttendanceRepository());

  // Use Cases
  getIt.registerLazySingleton(() => AuthLoginUseCase(getIt<IAuthRepository>()));
  getIt.registerLazySingleton(() => GetSchedulesUseCase(getIt<IScheduleRepository>()));
  getIt.registerLazySingleton(() => BanScheduleUseCase(getIt<IScheduleRepository>()));
  getIt.registerLazySingleton(() => GetTodayAttendanceUseCase(getIt<IAttendanceRepository>()));
  getIt.registerLazySingleton(() => GetMonthAttendanceUseCase(getIt<IAttendanceRepository>()));

  // Notifiers
  getIt.registerFactory(() => LoginNotifier(getIt<AuthLoginUseCase>()));
  getIt.registerFactory(() => ScheduleNotifier(getIt<GetSchedulesUseCase>()));
  getIt.registerFactory(() => HomeNotifier(
        getIt<GetTodayAttendanceUseCase>(),
        getIt<GetMonthAttendanceUseCase>(),
      ));
}
