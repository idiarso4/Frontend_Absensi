import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absen_smkn1_punggelan/app/presentation/attendance/schedule_notifier.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal'),
      ),
      body: Consumer<ScheduleNotifier>(
        builder: (context, notifier, child) {
          if (notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notifier.errorMessage.isNotEmpty) {
            return Center(child: Text(notifier.errorMessage));
          }

          if (notifier.schedules.isEmpty) {
            return const Center(child: Text('Belum ada jadwal'));
          }

          return ListView.builder(
            itemCount: notifier.schedules.length,
            itemBuilder: (context, index) {
              final schedule = notifier.schedules[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(schedule.day),
                  subtitle: Text('${schedule.checkIn} - ${schedule.checkOut}'),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        schedule.isActive ? Icons.check_circle : Icons.cancel,
                        color: schedule.isActive ? Colors.green : Colors.red,
                      ),
                      Text(
                        schedule.status,
                        style: TextStyle(
                          color: schedule.isActive ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
