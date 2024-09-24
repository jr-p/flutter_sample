import 'package:flutter_sample/src/constants/app_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // モック用の定数データ
  final String mockEmail = AppConst.mockEmail;
  final String mockPassword = AppConst.mockPassword;
  final String mockToken = AppConst.mockToken;

  // 登録リクエスト (モック版)
  Future<String?> register(String name, String email, String password) async {
    // 2秒の遅延をシミュレート
    await Future.delayed(const Duration(seconds: 2));

    // メールアドレスが既に存在しているかチェック（モックデータ）
    if (email == mockEmail) {
      throw Exception('このメールアドレスは既に使用されています');
    }

    // 登録成功を模倣
    return mockToken;
  }

  // ログインリクエスト (モック版)
  Future<String?> login(String email, String password) async {
    // 2秒の遅延をシミュレート
    await Future.delayed(const Duration(seconds: 2));

    // モックされたログイン認証
    if (email == mockEmail && password == mockPassword) {
      // トークンを保存
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', mockToken);

      // トークンを返す
      return mockToken;
    } else {
      throw Exception('ユーザー情報が正しくありません');
    }
  }

  // ログアウトリクエスト (モック版)
  Future<void> logout() async {
    // 2秒の遅延をシミュレート
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token != null) {
      // トークンを削除
      await prefs.remove('auth_token');
    }
    return;
  }

  // 認証状態のチェック (モック版)
  Future<bool> isAuthenticated() async {
    // 1秒の遅延をシミュレート
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_token');
  }
}