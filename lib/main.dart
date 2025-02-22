import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skansapung_presensi/app/presentation/login/login_screen.dart';
import 'package:skansapung_presensi/app/routes/app_routes.dart';
import 'package:skansapung_presensi/app/presentation/dashboard/dashboard_notifier.dart';
import 'package:skansapung_presensi/app/presentation/attendance/attendance_notifier.dart';
import 'package:skansapung_presensi/app/presentation/attendance/history_notifier.dart';
import 'package:skansapung_presensi/app/presentation/attendance/schedule_notifier.dart';
import 'package:skansapung_presensi/core/di/dependency.dart';
import 'package:skansapung_presensi/core/widget/error_app_widget.dart';
import 'package:skansapung_presensi/core/widget/loading_app_widget.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:skansapung_presensi/core/helper/notification_helper.dart';
import 'package:skansapung_presensi/app/presentation/leave/leave_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  await initDependency();
  await NotificationHelper.initNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardNotifier()),
        ChangeNotifierProvider(create: (_) => AttendanceNotifier()),
        ChangeNotifierProvider(create: (_) => HistoryNotifier()),
        ChangeNotifierProvider(create: (_) => ScheduleNotifier()),
        ChangeNotifierProvider(create: (_) => LeaveNotifier()),
      ],
      child: MaterialApp(
        title: 'PRESENSI SKANSAPUNG',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(243, 154, 0, 0.988),
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: AppBarTheme(
            backgroundColor: Color.fromRGBO(243, 154, 0, 0.988),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
