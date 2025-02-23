import 'package:flutter/material.dart';
import 'package:absen_smkn1_punggelan/app/core/result/result.dart';
import 'package:absen_smkn1_punggelan/app/domain/usecase/auth_login_usecase.dart';

class LoginNotifier extends ChangeNotifier {
  final AuthLoginUseCase _authLoginUseCase;
  bool _isLoading = false;
  String? _error;
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginNotifier(this._authLoginUseCase);

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isPasswordVisible => _isPasswordVisible;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  Future<bool> login() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authLoginUseCase(
        LoginParams(username: _emailController.text, password: _passwordController.text)
      );

      if (result is DataSuccess) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else if (result is DataFailed) {
        _error = result.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
