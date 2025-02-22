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
  Position? get currentPosition => _currentPosition;
  bool get isWithinRange => _isWithinRange;

  Future<void> checkLocation() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = 'Location services are disabled.';
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = 'Location permissions are denied.';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _errorMessage = 'Location permissions are permanently denied.';
        return;
      }

      // Get current position
      _currentPosition = await Geolocator.getCurrentPosition();
      
      // TODO: Check if within range of school
      // For now, just simulate the check
      _isWithinRange = true;

    } catch (e) {
      _errorMessage = 'Failed to get location: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> takePhoto() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );
      
      if (photo != null) {
        _selectedImage = File(photo.path);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to take photo: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> submitAttendance() async {
    if (_selectedImage == null || _currentPosition == null) {
      _errorMessage = 'Please take a photo and enable location';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement API call to submit attendance
      await Future.delayed(Duration(seconds: 2)); // Simulate API call
      
      // Clear data after successful submission
      _selectedImage = null;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to submit attendance: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }
}
