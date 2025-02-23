import 'package:flutter/material.dart';
import 'package:absen_smkn1_punggelan/app/presentation/dashboard/dashboard_screen.dart';
import 'package:absen_smkn1_punggelan/app/presentation/attendance/attendance_screen.dart';
import 'package:absen_smkn1_punggelan/app/presentation/attendance/history_screen.dart';
import 'package:absen_smkn1_punggelan/app/presentation/attendance/schedule_screen.dart';
import 'package:absen_smkn1_punggelan/app/presentation/leave/leave_screen.dart';
import 'package:absen_smkn1_punggelan/app/presentation/login/login_screen.dart';
import 'package:absen_smkn1_punggelan/app/presentation/home/home_screen.dart';
import 'package:absen_smkn1_punggelan/app/presentation/profile/profile_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    '/': (context) => LoginScreen(),
    '/home': (context) => HomeScreen(),
    '/profile': (context) => ProfileScreen(),
  };
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
