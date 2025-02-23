import 'package:flutter/material.dart';
import 'package:absen_smkn1_punggelan/app/core/result/result.dart';
import 'package:absen_smkn1_punggelan/app/data/model/attendance.dart';
import 'package:absen_smkn1_punggelan/app/domain/usecase/get_today_attendance_usecase.dart';
import 'package:absen_smkn1_punggelan/app/domain/usecase/get_month_attendance_usecase.dart';

class HomeNotifier extends ChangeNotifier {
  final GetTodayAttendanceUseCase _getTodayAttendanceUseCase;
  final GetMonthAttendanceUseCase _getMonthAttendanceUseCase;

  HomeNotifier(
    this._getTodayAttendanceUseCase,
    this._getMonthAttendanceUseCase,
  );

  bool _isLoading = false;
  String? _error;
  Attendance? _todayAttendance;
  List<Attendance> _monthAttendance = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  Attendance? get todayAttendance => _todayAttendance;
  List<Attendance> get monthAttendance => _monthAttendance;

  Future<void> getTodayAttendance() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _getTodayAttendanceUseCase();

      if (result is DataSuccess<Attendance>) {
        _todayAttendance = result.data;
      } else if (result is DataFailed<Attendance>) {
        _error = result.message;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getMonthAttendance() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _getMonthAttendanceUseCase();

      if (result is DataSuccess<List<Attendance>>) {
        _monthAttendance = result.data ?? [];
      } else if (result is DataFailed<List<Attendance>>) {
        _error = result.message;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
