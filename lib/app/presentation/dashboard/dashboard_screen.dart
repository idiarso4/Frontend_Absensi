import 'package:flutter/material.dart';
import 'package:skansapung_presensi/app/presentation/dashboard/dashboard_notifier.dart';
import 'package:skansapung_presensi/app/presentation/widgets/base_screen.dart';

class DashboardScreen extends BaseScreen<DashboardNotifier> {
  DashboardScreen() : super(title: 'Dashboard');

  @override
  Widget buildScreenContent(BuildContext context, DashboardNotifier notifier) {
    return RefreshIndicator(
      onRefresh: () => notifier.loadDashboardData(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            SizedBox(height: 20),
            _buildStatisticsGrid(notifier),
            SizedBox(height: 20),
            _buildRecentActivities(notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Datang!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Berikut ringkasan aktivitas Anda',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid(DashboardNotifier notifier) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          'Kehadiran',
          '${notifier.dashboardData['attendancePercentage']}%',
          Icons.check_circle,
          Colors.green,
        ),
        _buildStatCard(
          'Total Hadir',
          '${notifier.dashboardData['totalPresent']}',
          Icons.person,
          Colors.blue,
        ),
        _buildStatCard(
          'Total Absen',
          '${notifier.dashboardData['totalAbsent']}',
          Icons.person_off,
          Colors.red,
        ),
        _buildStatCard(
          'Terlambat',
          '${notifier.dashboardData['totalLate']}',
          Icons.timer_off,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities(DashboardNotifier notifier) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aktivitas Terkini',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            if (notifier.isLoading)
              Center(child: CircularProgressIndicator())
            else if (notifier.errorMessage.isNotEmpty)
              Center(
                child: Text(
                  notifier.errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: notifier.dashboardData['recentActivities']?.length ?? 0,
                itemBuilder: (context, index) {
                  final activity = notifier.dashboardData['recentActivities'][index];
                  return ListTile(
                    leading: Icon(
                      _getActivityIcon(activity['type']),
                      color: _getActivityColor(activity['type']),
                    ),
                    title: Text(activity['description']),
                    subtitle: Text(activity['time']),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'check_in':
        return Icons.login;
      case 'check_out':
        return Icons.logout;
      case 'break':
        return Icons.restaurant;
      default:
        return Icons.event_note;
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'check_in':
        return Colors.green;
      case 'check_out':
        return Colors.red;
      case 'break':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
