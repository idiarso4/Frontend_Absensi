import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:absen_smkn1_punggelan/app/module/entity/attendance.dart';
import 'package:absen_smkn1_punggelan/app/module/entity/schedule.dart';
import 'package:absen_smkn1_punggelan/app/module/use_case/attendance_get_this_month.dart';
import 'package:absen_smkn1_punggelan/app/module/use_case/attendance_get_today.dart';
import 'package:absen_smkn1_punggelan/app/module/use_case/schedule_banned.dart';
import 'package:absen_smkn1_punggelan/app/module/use_case/schedule_get.dart';
import 'package:absen_smkn1_punggelan/core/constant/constant.dart';
import 'package:absen_smkn1_punggelan/core/helper/date_time_helper.dart';
import 'package:absen_smkn1_punggelan/core/helper/notification_helper.dart';
import 'package:absen_smkn1_punggelan/core/helper/shared_preferences_helper.dart';
import 'package:absen_smkn1_punggelan/core/provider/app_provider.dart';
import 'package:flutter/material.dart';

class HomeNotifier extends AppProvider {
  final AttendanceGetTodayUseCase _attendanceGetTodayUseCase;
  final AttendanceGetMonthUseCase _attendanceGetMonthUseCase;
  final ScheduleGetUseCase _scheduleGetUseCase;
  final ScheduleBannedUseCase _scheduleBannedUseCase;

  HomeNotifier(this._attendanceGetTodayUseCase, this._attendanceGetMonthUseCase,
      this._scheduleGetUseCase, this._scheduleBannedUseCase) {
    init();
  }

  bool _isGrantedNotificationPresmission = false;
  int _timeNotification = 5;
  List<DropdownMenuEntry<int>> _listTimeNotification = [];
  String _name = '';
  String _email = '';
  String _role = '';
  String _profilePicture = '';
  String _deviceId = '';
  List<ScheduleEntity> _schedules = [];
  List<AttendanceEntity> _attendances = [];
  AttendanceEntity? _attendanceToday;

  bool get isGrantedNotificationPresmission => _isGrantedNotificationPresmission;
  int get timeNotification => _timeNotification;
  List<DropdownMenuEntry<int>> get listTimeNotification => _listTimeNotification;
  String get name => _name;
  String get email => _email;
  String get role => _role;
  String get profilePicture => _profilePicture;
  String get deviceId => _deviceId;
  List<ScheduleEntity> get schedules => _schedules;
  List<AttendanceEntity> get attendances => _attendances;
  AttendanceEntity? get attendanceToday => _attendanceToday;

  @override
  Future<void> init() async {
    await _getUserDetail();
    await _getDeviceInfo();
    await _getNotificationPermission();
    if (errorMessage.isEmpty) await _getAttendanceToday();
    if (errorMessage.isEmpty) await _getAttendanceThisMonth();
    if (errorMessage.isEmpty) await _getSchedule();
  }

  _getUserDetail() async {
    showLoading();
    _name = await SharedPreferencesHelper.getString(PREF_NAME);
    _email = await SharedPreferencesHelper.getString('email') ?? '';
    _role = await SharedPreferencesHelper.getString('role') ?? '';
    _profilePicture =
        await SharedPreferencesHelper.getString('profile_picture') ?? '';
    final pref_notif = await SharedPreferencesHelper.getInt(PREF_NOTIF_SETTING);
    if (pref_notif != null) {
      _timeNotification = pref_notif;
    } else {
      await SharedPreferencesHelper.setInt(
          PREF_NOTIF_SETTING, _timeNotification);
    }
    hideLoading();
  }

  _getDeviceInfo() async {
    showLoading();
    if (kIsWeb) {
      _isPhysicDevice = true; // Consider web as a physical device
    } else if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      _isPhysicDevice = androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      final iOSInfo = await DeviceInfoPlugin().iosInfo;
      _isPhysicDevice = iOSInfo.isPhysicalDevice;
    }

    if (!_isPhysicDevice) _sendBanned();
    hideLoading();
  }

  _getNotificationPermission() async {
    if (kIsWeb) {
      _isGrantedNotificationPresmission = false;
      return;
    }
    _isGrantedNotificationPresmission =
        await NotificationHelper.isPermissionGranted();
    if (!_isGrantedNotificationPresmission) {
      await NotificationHelper.requestPermission();
      await Future.delayed(Duration(seconds: 5));
      _getNotificationPermission();
    }
  }

  _getAttendanceToday() async {
    showLoading();
    final response = await _attendanceGetTodayUseCase();
    if (response.success) {
      _attendanceToday = response.data;
    } else {
      errorMeesage = response.message;
    }

    hideLoading();
  }

  _getAttendanceThisMonth() async {
    showLoading();
    final response = await _attendanceGetMonthUseCase();
    if (response.success) {
      _attendances = response.data!;
    } else {
      errorMeesage = response.message;
    }
    hideLoading();
  }

  _getSchedule() async {
    showLoading();
    _isLeaves = false;
    final response = await _scheduleGetUseCase();
    if (response.success) {
      if (response.data != null) {
        _schedules = response.data!;
        _schedules.sort((a, b) => a.startTime.compareTo(b.startTime));
      } else {
        _isLeaves = true;
        snackbarMessage = response.message;
      }
    } else {
      errorMeesage = response.message;
    }
    hideLoading();
  }

  _sendBanned() async {
    showLoading();
    final response = await _scheduleBannedUseCase();
    if (response.success) {
      _getSchedule();
    } else {
      errorMeesage = response.message;
    }
    hideLoading();
  }

  _setNotification() async {
    showLoading();

    await NotificationHelper.cancelAll();

    final startShift =
        await SharedPreferencesHelper.getString(PREF_START_SHIFT);
    final endShift = await SharedPreferencesHelper.getString(PREF_END_SHIFT);
    final prefTimeNotif =
        await SharedPreferencesHelper.getInt(PREF_NOTIF_SETTING);

    if (prefTimeNotif == null) {
      SharedPreferencesHelper.setInt(PREF_NOTIF_SETTING, _timeNotification);
    } else {
      _timeNotification = prefTimeNotif;
    }

    DateTime startShiftDateTime = DateTimeHelper.parseDateTime(
        dateTimeString: startShift, format: 'HH:mm:ss');

    DateTime endShiftDateTime = DateTimeHelper.parseDateTime(
        dateTimeString: endShift, format: 'HH:mm:ss');

    startShiftDateTime =
        startShiftDateTime.subtract(Duration(minutes: _timeNotification));
    endShiftDateTime =
        endShiftDateTime.subtract(Duration(minutes: _timeNotification));

    await NotificationHelper.scheduleNotification(
        id: 'start'.hashCode,
        title: 'Pengingat!',
        body: 'Jangan lupa untuk buat kehadiran datang',
        hour: startShiftDateTime.hour,
        minutes: startShiftDateTime.minute);

    await NotificationHelper.scheduleNotification(
        id: 'end'.hashCode,
        title: 'Pengingat!',
        body: 'Jangan lupa untuk buat kehadiran pulang',
        hour: endShiftDateTime.hour,
        minutes: endShiftDateTime.minute);
    hideLoading();
  }

  saveNotificationSetting(int param) async {
    showLoading();
    await SharedPreferencesHelper.setInt(PREF_NOTIF_SETTING, param);
    _timeNotification = param;
    _setNotification();
    hideLoading();
  }

  onChangeTimeNotification(int value) async {
    _timeNotification = value;
    await SharedPreferencesHelper.setInt(PREF_TIME_NOTIFICATION, value);
    notifyListeners();
  }

  onTapAllowNotification() async {
    _isGrantedNotificationPresmission =
        await NotificationHelper.requestNotificationPermission();
    notifyListeners();
  }

  onTapBannedSchedule(String id) async {
    showLoading();
    final response = await _scheduleBannedUseCase(id);
    if (response.success) {
      await _getSchedule();
    } else {
      snackbarMessage = response.message;
    }
    hideLoading();
  }

  String getTimeLeft(String startTime) {
    final now = DateTime.now();
    final time = DateTimeHelper.stringToDateTime(startTime);
    final difference = time.difference(now);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit';
    } else {
      return '${difference.inHours} jam';
    }
  }
}
