import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:absen_smkn1_punggelan/app/presentation/home/home_notifier.dart';
import 'package:absen_smkn1_punggelan/app/presentation/profile/profile_screen.dart';
import 'package:absen_smkn1_punggelan/app/presentation/schedule/schedule_screen.dart';
import 'package:absen_smkn1_punggelan/app/core/constants/preferences_keys.dart';
import 'package:absen_smkn1_punggelan/app/core/helper/shared_preferences_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = Provider.of<HomeNotifier>(context, listen: false);
    _loadData();
  }

  Future<void> _loadData() async {
    await _notifier.getTodayAttendance();
    await _notifier.getMonthAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Consumer<HomeNotifier>(
          builder: (context, notifier, child) {
            if (notifier.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfo(),
                  const SizedBox(height: 24),
                  _buildTodayAttendance(notifier),
                  const SizedBox(height: 24),
                  _buildMonthlyAttendance(notifier),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScheduleScreen()),
          );
        },
        child: const Icon(Icons.calendar_today),
      ),
    );
  }

  Widget _buildUserInfo() {
    final userName = SharedPreferencesHelper.getString(PreferencesKeys.userName) ?? 'User';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat datang,',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          userName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayAttendance(HomeNotifier notifier) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Absensi Hari Ini',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (notifier.todayAttendance != null) ...[
              _buildAttendanceTime('Masuk', notifier.todayAttendance!.checkIn),
              const SizedBox(height: 8),
              _buildAttendanceTime('Pulang', notifier.todayAttendance!.checkOut),
            ] else
              const Text('Belum ada absensi hari ini'),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceTime(String label, String? time) {
    return Row(
      children: [
        Icon(
          time != null ? Icons.check_circle : Icons.pending,
          color: time != null ? Colors.green : Colors.orange,
        ),
        const SizedBox(width: 8),
        Text(label),
        const Spacer(),
        Text(time ?? '-'),
      ],
    );
  }

  Widget _buildMonthlyAttendance(HomeNotifier notifier) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Absensi Bulan Ini',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (notifier.monthAttendance.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notifier.monthAttendance.length,
                itemBuilder: (context, index) {
                  final attendance = notifier.monthAttendance[index];
                  return ListTile(
                    title: Text(DateFormat('dd MMMM yyyy').format(attendance.date)),
                    subtitle: Text('${attendance.checkIn} - ${attendance.checkOut}'),
                    leading: const Icon(Icons.calendar_today),
                  );
                },
              )
            else
              const Text('Belum ada absensi bulan ini'),
          ],
        ),
      ),
    );
  }
}
