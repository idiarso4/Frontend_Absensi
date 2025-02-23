import 'package:absen_smkn1_punggelan/app/core/result/result.dart';
import 'package:absen_smkn1_punggelan/app/data/model/login_response.dart';
import 'package:absen_smkn1_punggelan/app/domain/repository/i_auth_repository.dart';
import 'package:absen_smkn1_punggelan/app/core/constants/preferences_keys.dart';
import 'package:absen_smkn1_punggelan/app/core/constants/api_constants.dart';
import 'package:absen_smkn1_punggelan/app/core/helper/shared_preferences_helper.dart';
import 'package:dio/dio.dart';

class AuthRepository implements IAuthRepository {
  final Dio _dio;

  AuthRepository({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<Result<LoginResponse>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.apiVersion}${ApiConstants.auth}${ApiConstants.login}',
        data: {
          'username': username,
          'password': password,
        },
      );
      
      final loginResponse = LoginResponse.fromJson(response.data['data']);
      
      // Save user data to SharedPreferences
      await SharedPreferencesHelper.setString(
        PreferencesKeys.token,
        '${loginResponse.tokenType} ${loginResponse.accessToken}'
      );
      await SharedPreferencesHelper.setInt(
        PreferencesKeys.userId,
        loginResponse.user.id
      );
      await SharedPreferencesHelper.setString(
        PreferencesKeys.userName,
        loginResponse.user.name
      );
      await SharedPreferencesHelper.setString(
        PreferencesKeys.userEmail,
        loginResponse.user.email
      );

      return DataSuccess(loginResponse);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
