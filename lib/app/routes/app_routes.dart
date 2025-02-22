import 'package:flutter/material.dart';
import 'package:skansapung_presensi/app/presentation/dashboard/dashboard_screen.dart';
import 'package:skansapung_presensi/app/presentation/attendance/attendance_screen.dart';
import 'package:skansapung_presensi/app/presentation/attendance/history_screen.dart';
import 'package:skansapung_presensi/app/presentation/attendance/schedule_screen.dart';
import 'package:skansapung_presensi/app/presentation/leave/leave_screen.dart';
import 'package:skansapung_presensi/app/presentation/login/login_screen.dart';
import 'package:skansapung_presensi/app/presentation/profile/profile_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String attendance = '/attendance';
  static const String attendanceCheck = '/attendance/check';
  static const String attendanceHistory = '/attendance/history';
  static const String attendanceSchedule = '/attendance/schedule';
  static const String leave = '/leave';
  static const String profile = '/profile';
  static const String learning = '/learning';
  static const String internship = '/internship';
  static const String worship = '/worship';
  static const String extracurricular = '/extracurricular';
  static const String counseling = '/counseling';
  static const String duty = '/duty';

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      home: (context) => LoginScreen(),
      login: (context) => LoginScreen(),
      dashboard: (context) => DashboardScreen(),
      attendance: (context) => AttendanceScreen(),
      attendanceCheck: (context) => AttendanceScreen(),
      attendanceHistory: (context) => HistoryScreen(),
      attendanceSchedule: (context) => ScheduleScreen(),
      leave: (context) => LeaveScreen(),
      profile: (context) => ProfileScreen(),
      learning: (context) => UnderConstructionScreen(title: 'Pembelajaran'),
      internship: (context) => UnderConstructionScreen(title: 'Magang'),
      worship: (context) => UnderConstructionScreen(title: 'Ibadah'),
      extracurricular: (context) => UnderConstructionScreen(title: 'Ekstrakurikuler'),
      counseling: (context) => UnderConstructionScreen(title: 'Konseling'),
      duty: (context) => UnderConstructionScreen(title: 'Tugas'),
    };
  }
}

class UnderConstructionScreen extends StatelessWidget {
  final String title;

  const UnderConstructionScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'Halaman dalam pengembangan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Fitur ini akan segera tersedia',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
