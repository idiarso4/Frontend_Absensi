import 'package:absen_smkn1_punggelan/app/module/entity/auth.dart';
import 'package:absen_smkn1_punggelan/app/module/entity/user_profile.dart';
import 'package:absen_smkn1_punggelan/core/network/data_state.dart';

abstract class AuthRepository {
  Future<DataState> login(AuthEntity param);
  Future<UserProfile> getUserProfile();
  Future<bool> checkProfileUpdatePermission();
  Future<void> updateProfile({
    required String name,
    required String phone,
    required String address,
  });
  Future<void> logout();
}
