import 'package:flutter_sample/src/services/api_exception.dart';
import 'package:flutter_sample/src/services/auth_service.dart';
import 'package:flutter/material.dart';

// 認証状態を管理するプロバイダー
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService(); // AuthServiceのインスタンスを作成
  bool _isAuthenticated = false;
  bool _isTwoAuthenticated = false;
  String? _message;

  bool get isAuthenticated => _isAuthenticated;
  bool get isTwoAuthenticated => _isTwoAuthenticated;
  String? get message => _message;

  // 登録処理
  Future<void> register(String name, String email, String phoneNumber, String password) async {
    try {
      _message = null;
      await _authService.register(name, email, phoneNumber, password);
      _isAuthenticated = true;
      _isTwoAuthenticated = false;
    } on ApiException catch (e) {
      _message = e.message;
    } catch (e) {
      _message = '登録に失敗しました';
    }
  }

  // ログイン処理
  Future<void> login(String email, String password) async {
    try { 
      _message = null;
      await _authService.login(email, password);
      _isAuthenticated = true;
      _isTwoAuthenticated = false;
    } on ApiException catch (e) {
      _message = e.message; 
    } catch (e) {
      _message = 'ログインに失敗しました';
    }
  }

  // 二段階認証処理
  Future<void> twoFactorAuth(String passcode) async {
    try {
      _message = null;
      await _authService.twoFactorAuth(passcode);
      _isTwoAuthenticated = true;
    } on ApiException catch (e) {
      _message = e.message;
    } catch (e) {
      _message = '認証に失敗しました'; 
    }
  }

  // 二段階認証再送処理
  Future<void> resendTwoFactorAuth() async {
    try {
      _message = null;
      await _authService.resendTwoFactorAuth();
      _message = '認証再送しました';
    } on ApiException catch (e) {
      _message = e.message;
    } catch (e) {
      _message = '認証再送に失敗しました';
    }
  }


  // ログアウト処理
  Future<void> logout() async {
    try {
      _message = null;
      await _authService.logout();
      _isAuthenticated = false;
      _isTwoAuthenticated = true;
    } on ApiException catch (e) {
      _message = e.message;
    } catch (e) {
      _message = 'ログアウトに失敗しました';
    }
  }

  // パスワードリセット処理
  Future<void> resetPassword(String email) async {
    try {
      _message = null;
      await _authService.resetPassword(email);
      _message = 'パスワードリセットメールを送信しました';
    } on ApiException catch (e) {
      _message = e.message;
    } catch (e) {
      _message = 'パスワードリセットに失敗しました';
    }
  }

  // トークンのチェック
  Future<void> checkAuthentication() async {
    _isAuthenticated = await _authService.isAuthenticated();
    if (isAuthenticated) {
      _isTwoAuthenticated = await _authService.isTwoAuthenticated();
    }
    notifyListeners();
  }

  // 電話番号更新成功
  Future<void> successPhoneNumber() async {
    _isAuthenticated = true;
    _isTwoAuthenticated = false;
  }

  // 退会成功
  Future<void> successWithidraw() async {
    _isAuthenticated = false;
    _isTwoAuthenticated = true;
  }
}
