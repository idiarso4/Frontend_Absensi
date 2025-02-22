import 'package:flutter/material.dart';
import 'package:absen_smkn1_punggelan/app/presentation/dashboard/dashboard_notifier.dart';
import 'package:absen_smkn1_punggelan/app/presentation/widgets/base_screen.dart';

class DashboardScreen extends BaseScreen<DashboardNotifier> {
  DashboardScreen() : super(title: 'Dashboard');

  @override
  Widget buildScreenContent(BuildContext context, DashboardNotifier notifier) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: () => notifier.loadDashboardData(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
          ),
        );
      },
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
          mainAxisSize: MainAxisSize.min,
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
      childAspectRatio: 1.2,
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
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: color),
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
                fontSize: 18,
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
          mainAxisSize: MainAxisSize.min,
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
                  textAlign: TextAlign.center,
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: notifier.recentActivities.length,
                itemBuilder: (context, index) {
                  final activity = notifier.recentActivities[index];
                  return ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text(activity.title),
                    subtitle: Text(activity.description),
                    trailing: Text(activity.time),
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
