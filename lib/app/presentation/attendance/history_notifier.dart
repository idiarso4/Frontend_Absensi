import 'package:flutter/material.dart';

class AttendanceRecord {
  final DateTime date;
  final String type; // 'check-in' or 'check-out'
  final TimeOfDay time;
  final String status; // 'on-time', 'late', 'absent'
  final String? photoUrl;
  final Map<String, double>? location;

  AttendanceRecord({
    required this.date,
    required this.type,
    required this.time,
    required this.status,
    this.photoUrl,
    this.location,
  });
}

class HistoryNotifier extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  List<AttendanceRecord> _records = [];
  DateTime _selectedMonth = DateTime.now();

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<AttendanceRecord> get records => _records;
  DateTime get selectedMonth => _selectedMonth;

  void setMonth(DateTime month) {
    _selectedMonth = month;
    loadHistory();
  }

  Future<void> loadHistory() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // TODO: Implement API call to fetch attendance history
      await Future.delayed(Duration(seconds: 1)); // Simulate API call

      // Simulate some sample data
      _records = List.generate(20, (index) {
        final date = DateTime.now().subtract(Duration(days: index));
        return AttendanceRecord(
          date: date,
          type: index % 2 == 0 ? 'check-in' : 'check-out',
          time: TimeOfDay(
            hour: index % 2 == 0 ? 7 + (index % 3) : 16 + (index % 3),
            minute: 30 + (index % 30),
          ),
          status: index % 5 == 0 ? 'late' : 'on-time',
          location: {
            'latitude': -6.2088 + (index * 0.001),
            'longitude': 106.8456 + (index * 0.001),
          },
        );
      });

      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load attendance history';
      print(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'on-time':
        return '#4CAF50'; // Green
      case 'late':
        return '#FFC107'; // Yellow
      case 'absent':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
