// features/auth/presentation/providers/auth_provider.dart
import 'package:absensi_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:absensi_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticateProvider with ChangeNotifier {
  final AuthRepository _authRepository;

  AuthenticateProvider() : _authRepository = AuthRepositoryImpl(FirebaseAuth.instance);

  bool _isAuthenticated = false;
  User? _user;

  bool get isAuthenticated => _isAuthenticated;
  User? get user => _user;

  Future<void> login(String email, String password) async {
    try {
      await _authRepository.loginWithEmailAndPassword(email, password);
      _isAuthenticated = true;
      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _isAuthenticated = false;
    _user = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    _isAuthenticated = await _authRepository.isLoggedIn();
    if (_isAuthenticated) {
      _user = FirebaseAuth.instance.currentUser;
    }
    notifyListeners();
  }
}
