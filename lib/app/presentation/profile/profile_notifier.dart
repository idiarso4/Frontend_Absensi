import 'package:flutter/material.dart';
import 'package:absen_smkn1_punggelan/core/helper/shared_preferences_helper.dart';
import 'package:absen_smkn1_punggelan/core/provider/app_provider.dart';
import 'package:absen_smkn1_punggelan/app/module/repository/auth_repository.dart';
import 'package:absen_smkn1_punggelan/app/module/repository/photo_repository.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class ProfileNotifier extends AppProvider {
  final AuthRepository _authRepository;
  final PhotoRepository _photoRepository;
  
  String _name = '';
  String _role = '';
  String _email = '';
  String _phone = '';
  String _nip = '';
  String _address = '';
  String? _profilePicture;
  bool _canUpdateProfile = false;
  bool _isLoading = false;

  bool get canUpdateProfile => _canUpdateProfile;
  bool get isLoading => _isLoading;
  String get name => _name;
  String get role => _role;
  String get email => _email;
  String get phone => _phone;
  String get nip => _nip;
  String get address => _address;
  String? get profilePicture => _profilePicture;

  ProfileNotifier({
    required AuthRepository authRepository,
    required PhotoRepository photoRepository,
  }) : _authRepository = authRepository,
       _photoRepository = photoRepository {
    init();
  }

  @override
  Future<void> init() async {
    try {
      setLoading(true);
      final userProfile = await _authRepository.getUserProfile();
      _role = userProfile.role;
      _email = userProfile.email;
      _phone = userProfile.phone;
      _nip = userProfile.nip;
      _address = userProfile.address;
      _name = userProfile.name;
      _profilePicture = userProfile.profilePicture;
      await checkProfileUpdatePermission();
      setLoading(false);
    } catch (e) {
      setLoading(false);
      debugPrint('Error initializing profile: $e');
    }
  }

  Future<void> checkProfileUpdatePermission() async {
    try {
      _canUpdateProfile = await _authRepository.checkProfileUpdatePermission();
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking profile update permission: $e');
      _canUpdateProfile = false;
      notifyListeners();
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    try {
      if (!_canUpdateProfile) {
        throw Exception('You do not have permission to update profile');
      }
      
      setLoading(true);
      await _authRepository.updateProfile(
        name: name,
        phone: phone,
        address: address,
      );
      
      _name = name;
      _phone = phone;
      _address = address;
      
      setLoading(false);
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }

  Future<void> updateProfilePicture(File imageFile) async {
    try {
      if (!_canUpdateProfile) {
        throw Exception('You do not have permission to update profile picture');
      }
      
      setLoading(true);
      final newProfilePicture = await _photoRepository.uploadProfilePhoto(imageFile);
      _profilePicture = newProfilePicture;
      setLoading(false);
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }

  Future<void> deleteProfilePicture() async {
    try {
      if (!_canUpdateProfile) {
        throw Exception('You do not have permission to delete profile picture');
      }
      
      setLoading(true);
      await _photoRepository.deleteProfilePhoto();
      _profilePicture = null;
      setLoading(false);
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }

  Future<void> fetchPhotoBytes(int id) async {
    final response = await _photoRepository.getPhotoBytes(id);
    if (response is SuccessState) {
        // Handle success, e.g., update state with photo bytes
    } else {
        // Handle error
    }
  }
}
