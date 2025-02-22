import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absen_smkn1_punggelan/app/presentation/attendance/history_notifier.dart';
import 'package:absen_smkn1_punggelan/app/presentation/widgets/base_screen.dart';

class HistoryScreen extends BaseScreen<HistoryNotifier> {
  const HistoryScreen({Key? key}) : super(title: 'Riwayat Absensi', key: key);

  @override
  Widget buildScreenContent(BuildContext context, HistoryNotifier notifier) {
    return Column(
      children: [
        _buildMonthSelector(notifier),
        Expanded(
          child: _buildHistoryList(notifier),
        ),
      ],
    );
  }

  Widget _buildMonthSelector(HistoryNotifier notifier) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              final newMonth = DateTime(
                notifier.selectedMonth.year,
                notifier.selectedMonth.month - 1,
              );
              notifier.setMonth(newMonth);
            },
          ),
          Text(
            DateFormat('MMMM yyyy').format(notifier.selectedMonth),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: () {
              final newMonth = DateTime(
                notifier.selectedMonth.year,
                notifier.selectedMonth.month + 1,
              );
              notifier.setMonth(newMonth);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(HistoryNotifier notifier) {
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
              onPressed: () => notifier.loadHistory(),
              child: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(243, 154, 0, 0.988),
              ),
            ),
          ],
        ),
      );
    }

    if (notifier.records.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada riwayat absensi untuk bulan ini',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: notifier.records.length,
      itemBuilder: (context, index) {
        final record = notifier.records[index];
        return _buildHistoryCard(record);
      },
    );
  }

  Widget _buildHistoryCard(AttendanceRecord record) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE, d MMMM yyyy').format(record.date),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(record.status),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTimeInfo(
                    'Check In',
                    record.checkIn,
                    Icons.login,
                    Colors.green,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTimeInfo(
                    'Check Out',
                    record.checkOut,
                    Icons.logout,
                    Colors.red,
                  ),
                ),
              ],
            ),
            if (record.note != null && record.note!.isNotEmpty) ...[
              SizedBox(height: 12),
              Text(
                'Catatan:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                record.note!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'hadir':
        color = Colors.green;
        break;
      case 'terlambat':
        color = Colors.orange;
        break;
      case 'alpha':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String label, TimeOfDay? time, IconData icon, Color color) {
    final formattedTime = time != null
        ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
        : '-';
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
