import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absen_smkn1_punggelan/app/presentation/login/login_screen.dart';
import 'package:absen_smkn1_punggelan/app/presentation/login/login_notifier.dart';
import 'package:absen_smkn1_punggelan/app/presentation/home/home_notifier.dart';
import 'package:absen_smkn1_punggelan/app/presentation/attendance/schedule_notifier.dart';
import 'package:absen_smkn1_punggelan/app/core/helper/shared_preferences_helper.dart';
import 'package:absen_smkn1_punggelan/app/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();
  await setupInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<LoginNotifier>()),
        ChangeNotifierProvider(create: (_) => getIt<HomeNotifier>()),
        ChangeNotifierProvider(create: (_) => getIt<ScheduleNotifier>()),
      ],
      child: MaterialApp(
        title: 'Absen SMKN 1 Punggelan',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
