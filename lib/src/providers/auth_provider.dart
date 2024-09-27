import 'package:flutter_sample/src/services/auth_service.dart';
import 'package:flutter/material.dart';

// 認証状態を管理するプロバイダー
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService(); // AuthServiceのインスタンスを作成
  bool _isAuthenticated = false;
  bool _isTwoAuthenticated = false;
  bool _isLoading = false;
  String? _message;

  bool get isAuthenticated => _isAuthenticated;
  bool get isTwoAuthenticated => _isTwoAuthenticated;
  bool get isLoading => _isLoading;
  String? get message => _message;

  // 登録処理
  Future<void> register(
      String name, String email, String phoneNumber, String password) async {
    try {
      _isLoading = true;
      _message = null;
      notifyListeners();

      final token = await _authService.register(name, email, phoneNumber, password);
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
        _isTwoAuthenticated = false;
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

  // 二段階認証処理
  Future<void> twoFactorAuth(String passcode) async {
    try {
      _isLoading = true;
      _message = null;
      notifyListeners();

      await _authService.twoFactorAuth(passcode);
      _isTwoAuthenticated = true;
      _isLoading = false;
      _message = null;
      notifyListeners();
      
    } catch (e) {
      // エラーハンドリング
      _message = e.toString().replaceAll('Exception:', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // 二段階認証再送処理
  Future<void> resendTwoFactorAuth() async {
    try {
      _isLoading = true;
      _message = null;
      notifyListeners();

      final result = await _authService.resendTwoFactorAuth();
      if (result) {
        _isLoading = false;
        _message = '再送しました';
        notifyListeners();
        _message = null;
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
    _isTwoAuthenticated = false;
    _isLoading = false;
    _message = null;
    notifyListeners();
  }

  // パスワードリセット処理
  Future<void> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    await _authService.resetPassword(email);
    _isLoading = false;
    _message = 'パスワードリセットメールを送信しました';
    notifyListeners();
  }

  // トークンのチェック
  Future<void> checkAuthentication() async {
    _isAuthenticated = await _authService.isAuthenticated();
    notifyListeners();
  }

  // 電話番号更新成功
  Future<void> successPhoneNumber() async {
    _isAuthenticated = true;
    _isTwoAuthenticated = false;
    notifyListeners();
  }

  // 退会成功
  Future<void> successWithidraw() async {
    _isAuthenticated = false;
    _isTwoAuthenticated = false;
    notifyListeners();
  }
}
