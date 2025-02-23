import 'package:absen_smkn1_punggelan/app/core/result/result.dart';
import 'package:absen_smkn1_punggelan/app/data/model/login_response.dart';
import 'package:absen_smkn1_punggelan/app/domain/repository/i_auth_repository.dart';

class AuthLoginUseCase {
  final IAuthRepository _repository;

  AuthLoginUseCase(this._repository);

  Future<Result<LoginResponse>> call(LoginParams params) {
    return _repository.login(params.username, params.password);
  }
}

class LoginParams {
  final String username;
  final String password;

  LoginParams({
    required this.username,
    required this.password,
  });
}
