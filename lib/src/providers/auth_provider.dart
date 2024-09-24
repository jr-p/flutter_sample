import 'package:flutter_sample/src/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService(); // AuthServiceのインスタンスを作成
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _message;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get message => _message;

  // 登録処理
  Future<void> register(
      String name, String email, String password) async {
    try {
      _isLoading = true;
      _message = null;
      notifyListeners();

      final token = await _authService.register(name, email,  password);
      if (token != null) {
        _isAuthenticated = true;
        _message = null;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      // エラーハンドリング
      _message = e.toString().replaceAll('Exception:', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // ログイン処理
  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      _message = null;
      notifyListeners();
      
      final token = await _authService.login(email, password);

      if (token != null) {
        _isAuthenticated = true;
        _isLoading = false;
        _message = null;
        notifyListeners();
      }
    } catch (e) {
      // エラーハンドリング
      _message = e.toString().replaceAll('Exception:', '');
      _isLoading = false;
      notifyListeners();
    }
  }


  // ログアウト処理
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await _authService.logout();
    _isAuthenticated = false;
    _isLoading = false;
    _message = null;
    notifyListeners();
  }

  // トークンのチェック
  Future<void> checkAuthentication() async {
    _isAuthenticated = await _authService.isAuthenticated();
    notifyListeners();
  }
}
