import 'dart:async';

import 'package:absen_smkn1_punggelan/app/module/entity/attendance.dart';
import 'package:absen_smkn1_punggelan/app/module/entity/schedule.dart';
import 'package:absen_smkn1_punggelan/app/module/use_case/attendance_send.dart';
import 'package:absen_smkn1_punggelan/app/module/use_case/schedule_banned.dart';
import 'package:absen_smkn1_punggelan/app/module/use_case/schedule_get.dart';
import 'package:absen_smkn1_punggelan/core/helper/date_time_helper.dart';
import 'package:absen_smkn1_punggelan/core/helper/location_helper.dart';
import 'package:absen_smkn1_punggelan/core/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';

class MapNotifier extends AppProvider {
  final ScheduleGetUseCase _scheduleGetUseCase;
  final AttendanceSendUseCase _attendanceSendUseCase;
  final ScheduleBannedUseCase _scheduleBannedUseCase;
  MapNotifier(this._scheduleGetUseCase, this._attendanceSendUseCase,
      this._scheduleBannedUseCase) {
    init();
  }

  bool _isSuccess = false;
  bool _isEnableSubmitButton = false;
  late MapController _mapController;
  ScheduleEntity? _schedule;
  late CircleOSM _circle;
  bool _isGrantedLocation = false;
  bool _isEnabledLocation = false;
  late StreamSubscription<Position> _streamCurrentLocation;
  GeoPoint? _currentLocation;

  bool get isSuccess => _isSuccess;
  bool get isEnableSubmitButton => _isEnableSubmitButton;
  MapController get mapController => _mapController;
  ScheduleEntity? get schedule => _schedule;
  bool get isGrantedLocation => _isGrantedLocation;
  bool get isEnabledLocation => _isEnabledLocation;

  @override
  void init() async {
    _mapController = MapController(
      initMapWithUserPosition: false,
      initPosition: GeoPoint(latitude: -6.17549964024, longitude: 106.827149391)
    );
    
    await _getEnableAndPermission();
    await _getSchedule();
    if (errorMessage.isEmpty) _checkShift();
  }

  Future<void> _getEnableAndPermission() async {
    try {
      _isEnabledLocation = await LocationHelper.isEnabledLocation();
      _isGrantedLocation = await LocationHelper.isGrantedLocation();
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> _getSchedule() async {
    try {
      final result = await _scheduleGetUseCase(null);
      _schedule = result.data;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  void _checkShift() {
    if (_schedule == null) return;
    
    final now = DateTime.now();
    final startTime = DateTimeHelper.stringToDateTime(_schedule!.startTime);
    final endTime = DateTimeHelper.stringToDateTime(_schedule!.endTime);
    
    if (now.isBefore(startTime) || now.isAfter(endTime)) {
      errorMessage = 'Bukan waktu absen';
      notifyListeners();
    }
  }

  Future<void> getCurrentLocation() async {
    if (!_isGrantedLocation || !_isEnabledLocation) return;

    _streamCurrentLocation = Geolocator.getPositionStream().listen((position) async {
      _currentLocation = GeoPoint(
        latitude: position.latitude,
        longitude: position.longitude
      );
      
      if (_currentLocation != null) {
        await _mapController.goToLocation(_currentLocation!);
      }
      
      notifyListeners();
    });
  }

  Future<void> submitAttendance() async {
    if (_currentLocation == null || _schedule == null) return;

    try {
      final attendance = AttendanceEntity(
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
        scheduleId: _schedule!.id
      );

      final result = await _attendanceSendUseCase(attendance);
      _isSuccess = result.data ?? false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _streamCurrentLocation.cancel();
    _mapController.dispose();
    super.dispose();
  }
}
