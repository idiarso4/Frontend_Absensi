import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skansapung_presensi/app/presentation/attendance/history_notifier.dart';
import 'package:skansapung_presensi/app/presentation/widgets/base_screen.dart';

class HistoryScreen extends BaseScreen<HistoryNotifier> {
  HistoryScreen() : super(title: 'Riwayat Absensi');

  @override
  Widget buildScreenContent(BuildContext context) {
    return Column(
      children: [
        _buildMonthSelector(),
        Expanded(
          child: _buildHistoryList(),
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
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

  Widget _buildHistoryList() {
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

    return RefreshIndicator(
      onRefresh: () => notifier.loadHistory(),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: notifier.records.length,
        itemBuilder: (context, index) {
          final record = notifier.records[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () => _showAttendanceDetail(context, record),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('dd MMMM yyyy').format(record.date),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(int.parse(
                              notifier.getStatusColor(record.status).substring(1),
                              radix: 16,
                            ) + 0xFF000000),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            record.status,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          record.type == 'check-in'
                              ? Icons.login
                              : Icons.logout,
                          color: Color.fromRGBO(243, 154, 0, 0.988),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${record.type == 'check-in' ? 'Masuk' : 'Pulang'} - ${notifier.formatTime(record.time)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    if (record.location != null) ...[
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Color.fromRGBO(243, 154, 0, 0.988),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Lat: ${record.location!['latitude']?.toStringAsFixed(6)}, Long: ${record.location!['longitude']?.toStringAsFixed(6)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAttendanceDetail(BuildContext context, AttendanceRecord record) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Absensi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            if (record.photoUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  record.photoUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
            _buildDetailRow('Tanggal', DateFormat('dd MMMM yyyy').format(record.date)),
            _buildDetailRow('Waktu', notifier.formatTime(record.time)),
            _buildDetailRow('Tipe', record.type == 'check-in' ? 'Masuk' : 'Pulang'),
            _buildDetailRow('Status', record.status),
            if (record.location != null)
              _buildDetailRow(
                'Lokasi',
                'Lat: ${record.location!['latitude']?.toStringAsFixed(6)}\nLong: ${record.location!['longitude']?.toStringAsFixed(6)}',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
