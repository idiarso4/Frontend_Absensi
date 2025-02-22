import 'package:flutter/material.dart';

class DashboardNotifier extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, dynamic> _dashboardData = {};

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Map<String, dynamic> get dashboardData => _dashboardData;

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
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load dashboard data';
      print(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }
}
