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
  String? _attendanceStatus;
  
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  File? get selectedImage => _selectedImage;
  Position? get currentLocation => _currentPosition;
  bool get isWithinRange => _isWithinRange;
  String? get attendanceStatus => _attendanceStatus;
  
  void clearPhoto() {
    _selectedImage = null;
    notifyListeners();
  }
  
  Future<void> takePhoto(BuildContext context) async {
    try {
      final String? imagePath = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => const CameraScreen(),
        ),
      );
  
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
    try {
      _isLoading = true;
      notifyListeners();
  
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = 'Izin lokasi ditolak';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }
  
      if (permission == LocationPermission.deniedForever) {
        _errorMessage = 'Izin lokasi ditolak secara permanen';
        _isLoading = false;
        notifyListeners();
        return;
      }
  
      _currentPosition = await Geolocator.getCurrentPosition();
      _isWithinRange = _checkIfWithinRange();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Gagal mendapatkan lokasi: ${e.toString()}';
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
      _targetLongitude
    );
    
    return distanceInMeters <= _allowedRadius;
  }
  
  Future<void> submitAttendance(BuildContext context) async {
    if (_selectedImage == null || _currentPosition == null) {
      _errorMessage = 'Please take a photo and enable location';
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
  
      Future<void> getCurrentLocation() async {
        try {
          final LocationPermission permission = await Geolocator.checkPermission();
          
          if (permission == LocationPermission.denied) {
            final LocationPermission requestedPermission = await Geolocator.requestPermission();
            if (requestedPermission == LocationPermission.denied) {
              _errorMessage = 'Location permission denied';
              notifyListeners();
              return;
            }
          }
          
          if (permission == LocationPermission.deniedForever) {
            _errorMessage = 'Location permissions are permanently denied';
            notifyListeners();
            return;
          }
          
          _isLoading = true;
          notifyListeners();
          
          _currentPosition = await Geolocator.getCurrentPosition();
          _isWithinRange = _checkIfWithinRange();
          _errorMessage = '';
        } catch (e) {
          _errorMessage = 'Error getting location: ${e.toString()}';
        } finally {
          _isLoading = false;
          notifyListeners();
        }
      }
      _isWithinRange = _checkIfWithinRange();
      if (!_isWithinRange) {
        _errorMessage = 'Anda berada di luar area yang diizinkan';
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error mendapatkan lokasi: ${e.toString()}';
      notifyListeners();
    }
  }
}
