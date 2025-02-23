import 'package:absen_smkn1_punggelan/app/core/result/result.dart';
import 'package:absen_smkn1_punggelan/app/data/model/login_response.dart';

abstract class IAuthRepository {
  Future<Result<LoginResponse>> login(String username, String password);
}
