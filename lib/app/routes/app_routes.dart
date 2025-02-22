import 'package:flutter/material.dart';
import 'package:skansapung_presensi/app/presentation/dashboard/dashboard_screen.dart';
import 'package:skansapung_presensi/app/presentation/attendance/attendance_screen.dart';
import 'package:skansapung_presensi/app/presentation/attendance/history_screen.dart';
import 'package:skansapung_presensi/app/presentation/attendance/schedule_screen.dart';
import 'package:skansapung_presensi/app/presentation/leave/leave_screen.dart';
import 'package:skansapung_presensi/app/presentation/login/login_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String attendance = '/attendance';
  static const String attendanceHistory = '/history';
  static const String attendanceSchedule = '/schedule';
  static const String leave = '/leave';

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      home: (context) => LoginScreen(),
      login: (context) => LoginScreen(),
      dashboard: (context) => DashboardScreen(),
      attendance: (context) => AttendanceScreen(),
      attendanceHistory: (context) => HistoryScreen(),
      attendanceSchedule: (context) => ScheduleScreen(),
      leave: (context) => LeaveScreen(),
    };
  }
}
