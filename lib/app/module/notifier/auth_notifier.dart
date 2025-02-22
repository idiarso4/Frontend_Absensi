import 'package:flutter/material.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String? nis;
  final String? photo;
  final String? nip;
  final String? phone;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? userType;
  final String? role;
  final String? status;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.nis,
    this.photo,
    this.nip,
    this.phone,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.userType,
    this.role,
    this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      nis: json['nis'],
      photo: json['photo'],
      nip: json['nip'],
      phone: json['phone'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userType: json['user_type'],
      role: json['role'],
      status: json['status'],
    );
  }
}

class AuthNotifier extends ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  String _errorMessage = '';

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void setUser(Map<String, dynamic> userData) {
    _user = User.fromJson(userData);
    notifyListeners();
  }

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _token = null;
    notifyListeners();
  }
}
