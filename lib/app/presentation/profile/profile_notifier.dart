import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:absen_smkn1_punggelan/core/constant/api_constants.dart';
import 'package:absen_smkn1_punggelan/core/helper/shared_preferences_helper.dart';

class ProfileNotifier extends ChangeNotifier {
  final _dio = Dio();
  bool _isLoading = false;
  bool _canUpdateProfile = false;
  String? _profilePicture;
  String _name = '';
  String _email = '';
  String _phone = '';
  String _role = '';
  String _nip = '';
  String _address = '';

  bool get isLoading => _isLoading;
  bool get canUpdateProfile => _canUpdateProfile;
  String? get profilePicture => _profilePicture;
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get role => _role;
  String get nip => _nip;
  String get address => _address;

  void showLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void hideLoading() {
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> _getToken() async {
    return await SharedPreferencesHelper.getString('token');
  }

  void _showSuccessMessage(String message) {
    // This will be handled by the UI
  }

  Future<void> initializeProfile() async {
    try {
      await checkProfileUpdatePermission();
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing profile: $e');
    }
  }

  Future<void> checkProfileUpdatePermission() async {
    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${await _getToken()}';

      final response = await dio.get(
        '${ApiConstants.baseUrl}/profile/check-update-permission',
      );

      if (response.data['success']) {
        _canUpdateProfile = response.data['data']['can_update_profile'];
      } else {
        _canUpdateProfile = false;
      }
    } catch (e) {
      _canUpdateProfile = false;
    }
    notifyListeners();
  }

  Future<void> uploadProfilePicture(BuildContext context, File file) async {
    try {
      _isLoading = true;
      notifyListeners();

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${await _getToken()}';

      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(file.path),
      });

      final response = await dio.post(
        '${ApiConstants.baseUrl}/api/profile/upload-photo',
        data: formData,
      );

      if (response.statusCode == 200) {
        _profilePicture = response.data['data']['photo_url'];
        _showSuccessMessage('Foto profil berhasil diperbarui');
      }
    } catch (e) {
      debugPrint('Error uploading profile picture: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProfilePicture(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${await _getToken()}';

      final response = await dio.delete(
        '${ApiConstants.baseUrl}/api/profile/delete-photo',
      );

      if (response.statusCode == 200) {
        _profilePicture = null;
        _showSuccessMessage('Foto profil berhasil dihapus');
      }
    } catch (e) {
      debugPrint('Error deleting profile picture: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changePassword(BuildContext context, String currentPassword, String newPassword) async {
    try {
      _isLoading = true;
      notifyListeners();

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${await _getToken()}';

      final response = await dio.post(
        '${ApiConstants.baseUrl}/api/profile/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        _showSuccessMessage('Password berhasil diubah');
      }
    } catch (e) {
      debugPrint('Error changing password: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? passwordConfirmation,
    File? photo,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${await _getToken()}';

      final formData = FormData.fromMap({
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (password != null) 'password': password,
        if (passwordConfirmation != null) 'password_confirmation': passwordConfirmation,
        if (photo != null) 'photo': await MultipartFile.fromFile(photo.path),
      });

      final response = await dio.post(
        '${ApiConstants.baseUrl}/api/profile/update',
        data: formData,
      );

      if (response.statusCode == 200) {
        _showSuccessMessage('Profil berhasil diperbarui');
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
