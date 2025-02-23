import 'package:flutter/material.dart';
import 'package:absen_smkn1_punggelan/app/core/result/result.dart';
import 'package:absen_smkn1_punggelan/app/data/model/schedule.dart';
import 'package:absen_smkn1_punggelan/app/domain/usecase/get_schedules_usecase.dart';

class ScheduleNotifier extends ChangeNotifier {
  final GetSchedulesUseCase _getSchedulesUseCase;

  ScheduleNotifier(this._getSchedulesUseCase) {
    loadSchedules();
  }

  bool _isLoading = false;
  String _errorMessage = '';
  List<Schedule> _schedules = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<Schedule> get schedules => _schedules;

  Future<void> loadSchedules() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await _getSchedulesUseCase();
      if (result is DataSuccess<List<Schedule>>) {
        _schedules = result.data ?? [];
      } else if (result is DataFailed<List<Schedule>>) {
        _errorMessage = result.message ?? 'Failed to load schedules';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
