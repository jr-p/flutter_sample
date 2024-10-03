import 'dart:convert';
import 'package:flutter_sample/src/constants/app_const.dart';
import 'package:flutter_sample/src/models/user_model.dart';
import 'package:flutter_sample/src/services/api_exception.dart';
import 'package:flutter_sample/src/utils/service_utils.dart';

// 設定画面関連のサービス
class SettingService {
  final baseApiUrl = AppConst.baseApiUrl;

  // ユーザー情報取得リクエスト
  Future<User> getUser() async {
    final token = await ServiceUtils.getToken();

    final response = await ServiceUtils.getRequest('user', token, null);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['data']);
    } else {
      final message = jsonDecode(response.body)['message'];
      throw ApiException(message ?? 'ユーザー情報の取得に失敗しました');
    }
  }

  // ユーザー情報更新リクエスト
  Future<void> updateUser(String email, String password) async {
    final token = await ServiceUtils.getToken();

    final requestData = jsonEncode({
      'email': email,
      'password': password,
    });

    final response = await ServiceUtils.putRequest('user', token, requestData);

    if (response.statusCode != 200) {
      final message = jsonDecode(response.body)['message'];
      throw ApiException(message ?? 'アカウント情報の更新に失敗しました');
    }
  }

  // ユーザー電話番号更新リクエスト
  Future<void> updatePhoneNumber(String phoneNumber) async {
    final token = await ServiceUtils.getToken();

    final requestData = jsonEncode({
      'phone_number': phoneNumber,
    });

    final response = await ServiceUtils.putRequest('user/phone', token, requestData);

    if (response.statusCode != 200) {
      final message = jsonDecode(response.body)['message'];
      throw ApiException(message ?? '電話番号の更新に失敗しました');
    }
  }

  // ユーザー退会リクエスト
  Future<void> withdraw() async {
    final token = await ServiceUtils.getToken();

    final response = await ServiceUtils.putRequest('user/withdraw', token, null);

    if (response.statusCode != 200) {
      final message = jsonDecode(response.body)['message'];
      throw ApiException(message ?? '退会に失敗しました');
    }
  }
}