import 'dart:convert';
import 'package:flutter_sample/src/constants/app_const.dart';
import 'package:flutter_sample/src/utils/service_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 認証関連のサービス
class AuthService {
  final String baseApiUrl = AppConst.baseApiUrl;

  // ユーザー重複チェックリクエスト
  Future<bool> checkUser(String email) async {
    final requestData = jsonEncode({
      'email': email,
    });

    final response = await ServiceUtils.postRequest('check-user', null, requestData);
    
    return response.statusCode == 200;
  }

  // 登録リクエスト
  Future<String?> register(String name, String email, String phoneNumber, String password) async {
    final requestData = jsonEncode({
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'password': password,
    });
    
    final response = await ServiceUtils.postRequest('register', null, requestData);
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      // トークンを保存
      await ServiceUtils.setToken(token);
      return token;
    } else if (response.statusCode == 409) {
      throw Exception('ユーザーが既に存在します');
    } else {
      throw Exception('登録に失敗しました');
    }

  }

  // ログインリクエスト
  Future<String?> login(String email, String password) async {
    final requestData = jsonEncode({
      'email': email,
      'password': password,
    });

    final response = await ServiceUtils.postRequest('login', null, requestData);
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      // トークンを保存
      await ServiceUtils.setToken(token);

      return token;
    } else if (response.statusCode == 401) {
      throw Exception('ユーザー情報が正しくありません');
    } else {
      throw Exception('ログインに失敗しました');
    }
  }

  // 二要素認証リクエスト
  Future<String> twoFactorAuth(String passcode) async {
    final token = await ServiceUtils.getToken();
    
    if (token != null) {
      final requestData = jsonEncode({
        'code': passcode,
      });

      final response = await ServiceUtils.postRequest('two-factor-auth', token, requestData);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        // トークンを保存
        await ServiceUtils.setToken(token);
        return token;
      } else if (response.statusCode == 401) {
        throw Exception('認証コードが正しくありません');
      } else {
        throw Exception('認証に失敗しました');
      }
    } else {
      throw Exception('ログインしていません');
    }
  }

  // 二要素認証再送リクエスト
  Future<bool> resendTwoFactorAuth() async {
    final token = await ServiceUtils.getToken();
    if (token != null) {
      await ServiceUtils.postRequest('resend-two-factor-code', token, null);
    }
    return true;
  }

  // ログアウトリクエスト
  Future<void> logout() async {
    final token = await ServiceUtils.getToken(); 
    
    if (token != null) {
      await ServiceUtils.postRequest('logout', token, null);
      // トークンを削除
      await ServiceUtils.removeToken();
    }
  }

  // パスワードリセットリクエスト
  Future<void> resetPassword(String email) async {
    final requestData = jsonEncode({
      'email': email,
    });

    await ServiceUtils.postRequest('reset-password', null, requestData);
  }

  // 認証状態のチェック
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_token');
  }
}