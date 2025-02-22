import 'package:flutter/material.dart';

class Activity {
  final String title;
  final String description;
  final String time;

  Activity({
    required this.title,
    required this.description,
    required this.time,
  });
}

class DashboardNotifier extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, dynamic> _dashboardData = {};
  List<Activity> _recentActivities = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Map<String, dynamic> get dashboardData => _dashboardData;
  List<Activity> get recentActivities => _recentActivities;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement API call to fetch dashboard data
      await Future.delayed(Duration(seconds: 1)); // Simulate API call
      _dashboardData = {
        'totalPresent': 20,
        'totalAbsent': 2,
        'totalLate': 1,
        'attendancePercentage': 87.5,
      };

      _recentActivities = [
        Activity(
          title: 'Presensi Masuk',
          description: 'Hari ini pukul 07:00',
          time: '07:00',
        ),
        Activity(
          title: 'Presensi Pulang',
          description: 'Hari ini pukul 15:00',
          time: '15:00',
        ),
      ];

      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load dashboard data';
      print(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }
}
