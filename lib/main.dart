import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absen_smkn1_punggelan/app/presentation/login/login_screen.dart';
import 'package:absen_smkn1_punggelan/app/presentation/login/login_notifier.dart';
import 'package:absen_smkn1_punggelan/app/routes/app_routes.dart';
import 'package:absen_smkn1_punggelan/app/presentation/dashboard/dashboard_notifier.dart';
import 'package:absen_smkn1_punggelan/app/presentation/attendance/attendance_notifier.dart';
import 'package:absen_smkn1_punggelan/app/presentation/attendance/history_notifier.dart';
import 'package:absen_smkn1_punggelan/app/presentation/attendance/schedule_notifier.dart';
import 'package:absen_smkn1_punggelan/core/di/dependency.dart';
import 'package:absen_smkn1_punggelan/core/widget/error_app_widget.dart';
import 'package:absen_smkn1_punggelan/core/widget/loading_app_widget.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:absen_smkn1_punggelan/core/helper/notification_helper.dart';
import 'package:absen_smkn1_punggelan/app/presentation/leave/leave_notifier.dart';
import 'package:absen_smkn1_punggelan/app/module/notifier/auth_notifier.dart';
import 'package:absen_smkn1_punggelan/app/presentation/profile/profile_notifier.dart';

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
        ChangeNotifierProvider(create: (_) => AuthNotifier()),
        ChangeNotifierProvider(create: (_) => LoginNotifier()),
        ChangeNotifierProvider(create: (_) => DashboardNotifier()),
        ChangeNotifierProvider(create: (_) => AttendanceNotifier()),
        ChangeNotifierProvider(create: (_) => HistoryNotifier()),
        ChangeNotifierProvider(create: (_) => ScheduleNotifier()),
        ChangeNotifierProvider(create: (_) => LeaveNotifier()),
        ChangeNotifierProvider(create: (_) => ProfileNotifier()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.red),
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
      ),
    );
  }
}
