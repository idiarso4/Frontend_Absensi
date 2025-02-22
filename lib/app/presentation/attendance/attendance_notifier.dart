import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AttendanceNotifier extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  File? _selectedImage;
  Position? _currentPosition;
  bool _isWithinRange = false;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  File? get selectedImage => _selectedImage;
  String? _attendanceStatus;
  String? get attendanceStatus => _attendanceStatus;

  Position? get currentLocation => _currentPosition;

  Future<void> takePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        _selectedImage = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to take photo: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> getCurrentLocation() async {
    await checkLocation();
  }

  Future<void> submitAttendance(BuildContext context) async {
    if (_selectedImage == null) {
      _errorMessage = 'Please take a photo first';
      notifyListeners();
      return;
    }

    if (_currentPosition == null) {
      _errorMessage = 'Please enable location services';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement attendance submission logic
      _attendanceStatus = 'Submitted';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = 'Location services are disabled';
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = 'Location permissions are denied';
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _errorMessage = 'Location permissions are permanently denied';
        notifyListeners();
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error getting location: ${e.toString()}';
      notifyListeners();
    }
  }
}
