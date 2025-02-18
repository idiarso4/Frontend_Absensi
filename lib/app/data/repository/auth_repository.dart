import 'package:absen_smkn1_punggelan/app/data/model/auth.dart';
import 'package:absen_smkn1_punggelan/app/data/source/auth_api_service.dart';
import 'package:absen_smkn1_punggelan/app/module/entity/auth.dart';
import 'package:absen_smkn1_punggelan/app/module/entity/user_profile.dart';
import 'package:absen_smkn1_punggelan/app/module/repository/auth_repository.dart';
import 'package:absen_smkn1_punggelan/core/constant/constant.dart';
import 'package:absen_smkn1_punggelan/core/helper/shared_preferences_helper.dart';
import 'package:absen_smkn1_punggelan/core/network/data_state.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthApiService _authApiService;

  AuthRepositoryImpl(this._authApiService);

  @override
  Future<DataState> login(AuthEntity param) async {
    try {
      final response = await _authApiService.login(body: param.toJson());
      if (response['success'] == true) {
        final authModel = AuthModel.fromJson(response['data']);
        await SharedPreferencesHelper.setString(
            PREF_AUTH, '${authModel.tokenType} ${authModel.accessToken}');
        await SharedPreferencesHelper.setInt(PREF_ID, authModel.user.id);
        await SharedPreferencesHelper.setString(PREF_NAME, authModel.user.name);
        await SharedPreferencesHelper.setString(
            PREF_EMAIL, authModel.user.email);
        return SuccessState(message: response['message'] ?? 'Login successful');
      } else {
        return ErrorState(message: response['message'] ?? 'Login failed');
      }
    } catch (e) {
      return ErrorState(message: e.toString());
    }
  }

  @override
  Future<UserProfile> getUserProfile() async {
    final response = await _authApiService.getProfile();
    if (response['success'] == true) {
      return UserProfile.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Failed to get profile');
    }
  }

  @override
  Future<bool> checkProfileUpdatePermission() async {
    final response = await _authApiService.checkProfileUpdatePermission();
    if (response['success'] == true) {
      return response['data']['can_update_profile'] ?? false;
    } else {
      throw Exception(response['message'] ?? 'Failed to check permission');
    }
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    final response = await _authApiService.updateProfile(body: {
      'name': name,
      'phone': phone,
      'address': address,
    });
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to update profile');
    }
  }

  @override
  Future<void> logout() async {
    await _authApiService.logout();
    await SharedPreferencesHelper.remove(PREF_AUTH);
    await SharedPreferencesHelper.remove(PREF_ID);
    await SharedPreferencesHelper.remove(PREF_NAME);
    await SharedPreferencesHelper.remove(PREF_EMAIL);
  }
}
