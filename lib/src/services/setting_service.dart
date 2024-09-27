import 'dart:convert';
import 'package:flutter_sample/src/constants/app_const.dart';
import 'package:flutter_sample/src/utils/service_utils.dart';

// 設定画面関連のサービス
class SettingService {
  final baseApiUrl = AppConst.baseApiUrl;

  // ユーザー情報取得リクエスト
  Future<Map<String, dynamic>> getUser() async {
    final token = await ServiceUtils.getToken();

    final response = await ServiceUtils.getRequest('user', token, null);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data['data']);
    } else {
      throw Exception('ユーザー情報の取得に失敗しました');
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
      throw Exception('アカウント情報の更新に失敗しました');
    }
  }

  // ユーザー電話番号更新リクエスト
  Future<bool> updatePhoneNumber(String phoneNumber) async {
    final token = await ServiceUtils.getToken();

    final requestData = jsonEncode({
      'phone_number': phoneNumber,
    });

    final response = await ServiceUtils.putRequest('user/phone', token, requestData);

    if (response.statusCode != 200) {
      throw Exception('電話番号の更新に失敗しました');
    } else {
      return true;
    }
  }

  // ユーザー退会リクエスト
  Future<bool> withdraw() async {
    final token = await ServiceUtils.getToken();

    final response = await ServiceUtils.putRequest('user/withdraw', token, null);

    if (response.statusCode != 200) {
      throw Exception('退会処理に失敗しました');
    } else {
      return true;
    }
  }
}