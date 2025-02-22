import 'package:flutter/material.dart';

class Schedule {
  final String day;
  final TimeOfDay checkIn;
  final TimeOfDay checkOut;
  final bool isActive;

  Schedule({
    required this.day,
    required this.checkIn,
    required this.checkOut,
    this.isActive = true,
  });
}

class ScheduleNotifier extends ChangeNotifier {
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
      // TODO: Implement API call to fetch schedules
      await Future.delayed(Duration(seconds: 1)); // Simulate API call

      // Simulate schedule data
      _schedules = [
        Schedule(
          day: 'Senin',
          checkIn: TimeOfDay(hour: 7, minute: 30),
          checkOut: TimeOfDay(hour: 16, minute: 0),
        ),
        Schedule(
          day: 'Selasa',
          checkIn: TimeOfDay(hour: 7, minute: 30),
          checkOut: TimeOfDay(hour: 16, minute: 0),
        ),
        Schedule(
          day: 'Rabu',
          checkIn: TimeOfDay(hour: 7, minute: 30),
          checkOut: TimeOfDay(hour: 16, minute: 0),
        ),
        Schedule(
          day: 'Kamis',
          checkIn: TimeOfDay(hour: 7, minute: 30),
          checkOut: TimeOfDay(hour: 16, minute: 0),
        ),
        Schedule(
          day: 'Jumat',
          checkIn: TimeOfDay(hour: 7, minute: 30),
          checkOut: TimeOfDay(hour: 16, minute: 30),
        ),
        Schedule(
          day: 'Sabtu',
          checkIn: TimeOfDay(hour: 7, minute: 30),
          checkOut: TimeOfDay(hour: 13, minute: 0),
        ),
        Schedule(
          day: 'Minggu',
          checkIn: TimeOfDay(hour: 0, minute: 0),
          checkOut: TimeOfDay(hour: 0, minute: 0),
          isActive: false,
        ),
      ];

      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load schedules';
      print(e.toString());
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
