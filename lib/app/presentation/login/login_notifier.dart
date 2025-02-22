import 'package:flutter/material.dart';
import 'package:absen_smkn1_punggelan/app/module/entity/auth.dart';
import 'package:absen_smkn1_punggelan/app/module/use_case/auth_login.dart';
import 'package:absen_smkn1_punggelan/core/network/data_state.dart';
import 'package:absen_smkn1_punggelan/core/constant/constant.dart';
import 'package:absen_smkn1_punggelan/core/helper/shared_preferences_helper.dart';

class LoginNotifier extends ChangeNotifier {
  final AuthLoginUseCase _authLoginUseCase;

  LoginNotifier(this._authLoginUseCase);

  bool _isLoading = false;
  bool _isShowPassword = false;
  String _errorMessage = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get isLoading => _isLoading;
  bool get isShowPassword => _isShowPassword;
  String get errorMessage => _errorMessage;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  void togglePasswordVisibility() {
    _isShowPassword = !_isShowPassword;
    notifyListeners();
  }

  Future<bool> login() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (!email.contains('@skansa.com')) {
        _errorMessage = 'Email harus menggunakan domain @skansa.com';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.isEmpty) {
        _errorMessage = 'Password tidak boleh kosong';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final param = AuthEntity(email: email, password: password);
      final result = await _authLoginUseCase.call(param);

      if (result is DataSuccess) {
        await SharedPreferencesHelper.setString(
          PreferencesKeys.token,
          result.data?.token ?? '',
        );
        _errorMessage = '';
        return true;
      } else if (result is DataFailed) {
        _errorMessage = result.error?.message ?? 'Terjadi kesalahan';
        return false;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
