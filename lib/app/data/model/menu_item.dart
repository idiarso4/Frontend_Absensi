import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final String route;
  final List<MenuItem> subMenus;

  const MenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.subMenus = const [],
  });
}

class MenuItems {
  static const dashboard = MenuItem(
    title: 'Dashboard',
    icon: Icons.dashboard,
    route: '/dashboard',
  );

  static const attendance = MenuItem(
    title: 'Absensi',
    icon: Icons.calendar_today,
    route: '/attendance',
    subMenus: [
      MenuItem(
        title: 'Check In/Out',
        icon: Icons.access_time,
        route: '/attendance/check',
      ),
      MenuItem(
        title: 'Riwayat',
        icon: Icons.history,
        route: '/attendance/history',
      ),
      MenuItem(
        title: 'Jadwal',
        icon: Icons.schedule,
        route: '/attendance/schedule',
      ),
    ],
  );

  static const leave = MenuItem(
    title: 'Cuti & Izin',
    icon: Icons.event_busy,
    route: '/leave',
  );

  static const profile = MenuItem(
    title: 'Profil',
    icon: Icons.person,
    route: '/profile',
  );

  static const learning = MenuItem(
    title: 'Pembelajaran',
    icon: Icons.school,
    route: '/learning',
  );

  static const internship = MenuItem(
    title: 'PKL',
    icon: Icons.work,
    route: '/internship',
  );

  static const worship = MenuItem(
    title: 'Jadwal Ibadah',
    icon: Icons.mosque,
    route: '/worship',
  );

  static const academic = MenuItem(
    title: 'Akademik',
    icon: Icons.book,
    route: '/academic',
    subMenus: [
      MenuItem(
        title: 'Kelas',
        icon: Icons.class_,
        route: '/academic/class',
      ),
      MenuItem(
        title: 'Mata Pelajaran',
        icon: Icons.subject,
        route: '/academic/subjects',
      ),
      MenuItem(
        title: 'Nilai',
        icon: Icons.grade,
        route: '/academic/grades',
      ),
    ],
  );

  static const extracurricular = MenuItem(
    title: 'Ekstrakurikuler',
    icon: Icons.sports_soccer,
    route: '/extracurricular',
  );

  static const counseling = MenuItem(
    title: 'Bimbingan Konseling',
    icon: Icons.psychology,
    route: '/counseling',
  );

  static const duty = MenuItem(
    title: 'Piket & Perizinan',
    icon: Icons.assignment,
    route: '/duty',
  );

  static const List<MenuItem> mainMenuItems = [
    dashboard,
    attendance,
    leave,
    profile,
    learning,
    internship,
    worship,
    academic,
    extracurricular,
    counseling,
    duty,
  ];
}
