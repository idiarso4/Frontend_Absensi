import 'package:flutter/material.dart';
import 'package:skansapung_presensi/app/presentation/home/home_screen.dart';
import 'package:skansapung_presensi/app/presentation/dashboard/dashboard_screen.dart';
import 'package:skansapung_presensi/app/presentation/attendance/attendance_screen.dart';
import 'package:skansapung_presensi/app/presentation/attendance/history_screen.dart';
import 'package:skansapung_presensi/app/presentation/attendance/schedule_screen.dart';
import 'package:skansapung_presensi/app/presentation/leave/leave_screen.dart';
import 'package:skansapung_presensi/app/presentation/profile/profile_screen.dart';
import 'package:skansapung_presensi/app/presentation/learning/learning_screen.dart';
import 'package:skansapung_presensi/app/presentation/internship/internship_screen.dart';
import 'package:skansapung_presensi/app/presentation/worship/worship_screen.dart';
import 'package:skansapung_presensi/app/presentation/academic/academic_screen.dart';
import 'package:skansapung_presensi/app/presentation/academic/class_screen.dart';
import 'package:skansapung_presensi/app/presentation/academic/subjects_screen.dart';
import 'package:skansapung_presensi/app/presentation/academic/grades_screen.dart';
import 'package:skansapung_presensi/app/presentation/extracurricular/extracurricular_screen.dart';
import 'package:skansapung_presensi/app/presentation/counseling/counseling_screen.dart';
import 'package:skansapung_presensi/app/presentation/duty/duty_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String attendance = '/attendance/check';
  static const String attendanceHistory = '/attendance/history';
  static const String attendanceSchedule = '/attendance/schedule';
  static const String leave = '/leave';
  static const String profile = '/profile';
  static const String learning = '/learning';
  static const String internship = '/internship';
  static const String worship = '/worship';
  static const String academic = '/academic';
  static const String academicClass = '/academic/class';
  static const String academicSubjects = '/academic/subjects';
  static const String academicGrades = '/academic/grades';
  static const String extracurricular = '/extracurricular';
  static const String counseling = '/counseling';
  static const String duty = '/duty';

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      '/dashboard': (context) => DashboardScreen(),
      '/attendance': (context) => AttendanceScreen(),
      '/history': (context) => HistoryScreen(),
      '/schedule': (context) => ScheduleScreen(),
      '/leave': (context) => LeaveScreen(),
    };
  }
}
