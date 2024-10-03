import 'dart:convert';
import 'package:flutter_sample/src/constants/app_const.dart';
import 'package:flutter_sample/src/services/api_exception.dart';
import 'package:flutter_sample/src/utils/service_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 認証関連のサービス
class AuthService {
  final String baseApiUrl = AppConst.baseApiUrl;

  // ユーザー重複チェックリクエスト
  Future<void> checkUser(String email) async {
    final requestData = jsonEncode({
      'email': email,
    });

    final response = await ServiceUtils.postRequest('check-user', null, requestData);
    
    if (response.statusCode != 200) {
      final message = jsonDecode(response.body)['message'] ?? 'ユーザーが存在します';
      throw ApiException(message);
    }
  }

  // 登録リクエスト
  Future<void> register(String name, String email, String phoneNumber, String password) async {
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
    } else {
      final message = jsonDecode(response.body)['message'] ?? '登録に失敗しました';
      throw ApiException(message);
    } 

  }

  // ログインリクエスト
  Future<void> login(String email, String password) async {
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
    } else {
      final message = jsonDecode(response.body)['message'] ?? 'ログインに失敗しました';
      throw ApiException(message);
    }
  }

  // 二要素認証リクエスト
  Future<void> twoFactorAuth(String passcode) async {
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
      } else {
        final message = jsonDecode(response.body)['message'] ?? '二要素認証に失敗しました';
        throw ApiException(message);
      } 
    } else {
      throw Exception('ログインしていません');
    }
  }

  // 二要素認証再送リクエスト
  Future<void> resendTwoFactorAuth() async {
    final token = await ServiceUtils.getToken();
    if (token != null) {
      final response = await ServiceUtils.postRequest('resend-two-factor-code', token, null);
      
      if (response.statusCode != 200) {
        final message = jsonDecode(response.body)['message'] ?? '二要素認証コードの再送に失敗しました';
        throw ApiException(message);
      }
    }
  }

  // ログアウトリクエスト
  Future<void> logout() async {
    final token = await ServiceUtils.getToken(); 
    
    if (token != null) {
      final response = await ServiceUtils.postRequest('logout', token, null);
      if (response.statusCode != 200) {
        final message = jsonDecode(response.body)['message'] ?? 'ログアウトに失敗しました';
        throw ApiException(message);
      }
      // トークンを削除
      await ServiceUtils.removeToken();
    }
  }

  // パスワードリセットリクエスト
  Future<void> resetPassword(String email) async {
    final requestData = jsonEncode({
      'email': email,
    });

    final response = await ServiceUtils.postRequest('reset-password', null, requestData);
    if (response.statusCode != 200) {
      final message = jsonDecode(response.body)['message'] ?? 'パスワードリセットに失敗しました';
      throw ApiException(message);
    }
  }

  // 認証状態のチェック
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_token');
  }

  // 二要素認証済みかのチェック
  Future<bool> isTwoAuthenticated() async {
    final token = await ServiceUtils.getToken();
    if (token != null) {
      final response = await ServiceUtils.getRequest('check-two-factor-auth', token, null);
      if (response.statusCode == 200) {
        final isTwoAuthenticated = jsonDecode(response.body)['is_two_authenticated'];
        return isTwoAuthenticated;
      }
    }
    return false;
  }
}