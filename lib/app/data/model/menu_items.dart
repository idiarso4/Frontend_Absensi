import 'package:flutter/material.dart';
import 'package:absen_smkn1_punggelan/app/data/model/menu_item.dart';

class MenuItems {
  static final List<MenuItem> mainMenuItems = [
    MenuItem(
      title: 'Beranda',
      icon: Icons.home,
      route: '/home',
      subMenus: [],
    ),
    MenuItem(
      title: 'Profil',
      icon: Icons.person,
      route: '/profile',
      subMenus: [],
    ),
    MenuItem(
      title: 'Presensi',
      icon: Icons.camera_alt,
      route: '/attendance',
      subMenus: [],
    ),
    MenuItem(
      title: 'Riwayat',
      icon: Icons.history,
      route: '/history',
      subMenus: [],
    ),
    MenuItem(
      title: 'Jadwal',
      icon: Icons.calendar_today,
      route: '/schedule',
      subMenus: [],
    ),
  ];
}
