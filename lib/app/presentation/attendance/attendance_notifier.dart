import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'camera_screen.dart';
import 'dart:io';

class AttendanceNotifier extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  File? _selectedImage;
  Position? _currentPosition;
  bool _isWithinRange = false;
  final double _targetLatitude = -7.4171; // Latitude sekolah
  final double _targetLongitude = 109.6778; // Longitude sekolah
  final int _allowedRadius = 100; // Radius dalam meter

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  File? get selectedImage => _selectedImage;
  String? _attendanceStatus;
  String? get attendanceStatus => _attendanceStatus;
  Position? get currentLocation => _currentPosition;
  bool get isWithinRange => _isWithinRange;

  void clearPhoto() {
    _selectedImage = null;
    notifyListeners();
  }

  Future<void> takePhoto(BuildContext context) async {
    try {
      // Buka camera screen
      final String? imagePath = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CameraScreen(),
        ),
      );

      // Jika berhasil mengambil foto
      if (imagePath != null) {
        _selectedImage = File(imagePath);
        _errorMessage = '';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Gagal mengambil foto: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> getCurrentLocation() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await checkLocation();
      if (_currentPosition != null) {
        _isWithinRange = _checkIfWithinRange();
        if (!_isWithinRange) {
          _errorMessage = 'Anda berada di luar area yang diizinkan';
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _checkIfWithinRange() {
    if (_currentPosition == null) return false;
    
    final double distanceInMeters = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      _targetLatitude,
      _targetLongitude,
    );
    
    return distanceInMeters <= _allowedRadius;
  }

  Future<void> submitAttendance(BuildContext context) async {
    if (_selectedImage == null) {
      _errorMessage = 'Silakan ambil foto terlebih dahulu';
      notifyListeners();
      return;
    }

    if (_currentPosition == null) {
      _errorMessage = 'Silakan aktifkan layanan lokasi';
      notifyListeners();
      return;
    }

    if (!_isWithinRange) {
      _errorMessage = 'Anda harus berada di area sekolah untuk melakukan absensi';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement attendance submission to API
      await Future.delayed(Duration(seconds: 2)); // Simulate API call
      _attendanceStatus = 'Hadir';
      _errorMessage = '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Absensi berhasil terkirim'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _errorMessage = 'Gagal mengirim absensi: ${e.toString()}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = 'Layanan lokasi tidak aktif';
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = 'Izin lokasi ditolak';
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _errorMessage = 'Izin lokasi ditolak secara permanen';
        notifyListeners();
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error mendapatkan lokasi: ${e.toString()}';
      notifyListeners();
    }
  }
}
