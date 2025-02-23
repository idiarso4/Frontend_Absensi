import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:absen_smkn1_punggelan/app/data/model/schedule.dart';
import 'package:absen_smkn1_punggelan/app/presentation/attendance/schedule_notifier.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Absensi'),
        backgroundColor: const Color.fromRGBO(243, 154, 0, 0.988),
      ),
      body: Consumer<ScheduleNotifier>(
        builder: (context, notifier, _) {
          return RefreshIndicator(
            onRefresh: () => notifier.loadSchedules(),
            child: _buildScheduleList(notifier),
          );
        },
      ),
    );
  }

  Widget _buildScheduleList(ScheduleNotifier notifier) {
    if (notifier.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notifier.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              notifier.errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => notifier.loadSchedules(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(243, 154, 0, 0.988),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Status:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          _StatusLegendItem(
            color: Colors.green,
            text: 'Sudah Absen',
          ),
          SizedBox(height: 4),
          _StatusLegendItem(
            color: Colors.orange,
            text: 'Belum Absen',
          ),
          SizedBox(height: 4),
          _StatusLegendItem(
            color: Colors.red,
            text: 'Tidak Absen',
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(Schedule schedule) {
    final Color statusColor = _getStatusColor(schedule.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(schedule.date),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(schedule.status),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTimeRow('Masuk', schedule.checkIn),
          const SizedBox(height: 8),
          _buildTimeRow('Pulang', schedule.checkOut),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String label, String time) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        const Text(
          ':',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _formatTime(time),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat('EEEE, d MMMM y', 'id_ID').format(dateTime);
  }

  String _formatTime(String time) {
    return DateFormat('HH:mm').format(DateTime.parse('2024-01-01 $time'));
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'done':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'missed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'done':
        return 'Sudah Absen';
      case 'pending':
        return 'Belum Absen';
      case 'missed':
        return 'Tidak Absen';
      default:
        return 'Unknown';
    }
  }
}

class _StatusLegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _StatusLegendItem({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
