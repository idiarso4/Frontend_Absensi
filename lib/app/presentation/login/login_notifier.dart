import 'package:flutter/material.dart';
import 'package:skansapung_presensi/app/module/use_case/auth_login.dart';
import 'package:skansapung_presensi/app/module/entity/auth.dart';
import 'package:skansapung_presensi/core/network/data_state.dart';

class LoginNotifier extends ChangeNotifier {
  final AuthLoginUseCase _authLoginUseCase;

  LoginNotifier(this._authLoginUseCase);

  bool _isLoading = false;
  bool _isShowPassword = false;
  String _errorMessage = '';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get isLoading => _isLoading;
  bool get isShowPassword => _isShowPassword;
  String get errorMessage => _errorMessage;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get passwordController => _passwordController;

  void togglePasswordVisibility() {
    _isShowPassword = !_isShowPassword;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      if (!username.contains('@')) {
        _errorMessage = 'Please enter a valid email address';
        return false;
      }

      if (!username.endsWith('@skansa.com')) {
        _errorMessage = 'Please use your @skansa.com email';
        return false;
      }

      final result = await _authLoginUseCase.call(
        param: Auth.entity(
          email: username,
          password: password,
        ) as AuthEntity,
      );

      if (result is SuccessState) {
        _errorMessage = '';
        return true;
      } else if (result is ErrorState) {
        print('Login error: ${result.message}'); // Debug print
        if (result.message.toLowerCase().contains('unauthorized') ||
            result.message.toLowerCase().contains('invalid')) {
          _errorMessage = 'Invalid email or password';
        } else if (result.message.toLowerCase().contains('network') ||
            result.message.toLowerCase().contains('connection')) {
          _errorMessage = 'Network error. Please check your internet connection.';
        } else {
          _errorMessage = result.message;
        }
        return false;
      } else {
        _errorMessage = 'An unexpected error occurred';
        return false;
      }
    } catch (e) {
      print('Login exception: $e'); // Debug print
      if (e.toString().toLowerCase().contains('connection refused')) {
        _errorMessage = 'Could not connect to server. Please try again later.';
      } else if (e.toString().toLowerCase().contains('network')) {
        _errorMessage = 'Network error. Please check your internet connection.';
      } else {
        _errorMessage = e.toString();
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
