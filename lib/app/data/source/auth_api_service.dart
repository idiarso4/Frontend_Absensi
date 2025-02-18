import 'package:absen_smkn1_punggelan/core/constant/constant.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'auth_api_service.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class AuthApiService {
  factory AuthApiService(Dio dio) {
    return _AuthApiService(dio);
  }

  @POST('/api/login')
  Future<Map<String, dynamic>> login(
      {@Body() required Map<String, dynamic> body});

  @GET('/api/profile')
  Future<Map<String, dynamic>> getProfile();

  @GET('/api/profile/check-update-permission')
  Future<Map<String, dynamic>> checkProfileUpdatePermission();

  @POST('/api/profile/update')
  Future<Map<String, dynamic>> updateProfile(
      {@Body() required Map<String, dynamic> body});

  @POST('/api/logout')
  Future<void> logout();
}
