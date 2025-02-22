import 'package:flutter/material.dart';
import 'package:skansapung_presensi/app/presentation/attendance/schedule_notifier.dart';
import 'package:skansapung_presensi/app/presentation/widgets/base_screen.dart';

class ScheduleScreen extends BaseScreen<ScheduleNotifier> {
  ScheduleScreen() : super(title: 'Jadwal Absensi');

  @override
  Widget buildScreenContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => notifier.loadSchedules(),
      child: _buildScheduleList(),
    );
  }

  Widget _buildScheduleList() {
    if (notifier.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (notifier.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              notifier.errorMessage,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => notifier.loadSchedules(),
              child: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(243, 154, 0, 0.988),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: notifier.schedules.length + 1, // +1 for the legend
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildLegend();
        }
        final schedule = notifier.schedules[index - 1];
        return _buildScheduleCard(schedule);
      },
    );
  }

  Widget _buildLegend() {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Keterangan Jadwal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 12,
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                Text('Aktif'),
                SizedBox(width: 24),
                Icon(
                  Icons.circle,
                  size: 12,
                  color: Colors.grey,
                ),
                SizedBox(width: 8),
                Text('Tidak Aktif'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(Schedule schedule) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: schedule.isActive ? Colors.green : Colors.grey,
            width: 2,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    schedule.day,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: schedule.isActive ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      schedule.isActive ? 'Aktif' : 'Tidak Aktif',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              if (schedule.isActive) ...[
                _buildTimeRow(
                  'Jam Masuk',
                  notifier.formatTime(schedule.checkIn),
                  Icons.login,
                ),
                SizedBox(height: 8),
                _buildTimeRow(
                  'Jam Pulang',
                  notifier.formatTime(schedule.checkOut),
                  Icons.logout,
                ),
              ] else
                Text(
                  'Libur',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRow(String label, String time, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Color.fromRGBO(243, 154, 0, 0.988),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        SizedBox(width: 8),
        Text(
          time,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
