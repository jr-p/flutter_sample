import 'dart:convert';
import 'package:flutter_sample/src/constants/app_const.dart';
import 'package:flutter_sample/src/models/item_model.dart';
import 'package:flutter_sample/src/services/api_exception.dart';
import 'package:flutter_sample/src/utils/service_utils.dart';

// ホーム画面関連のサービス
class HomeService {
  final String baseApiUrl = AppConst.baseApiUrl;

  // Itemリスト取得リクエスト
  Future<List<Item>> getItems(int? page) async {
    final token = await ServiceUtils.getToken();

    final param = page != null ? 'page=$page' : null;
    final response = await ServiceUtils.getRequest('items', token, param);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List).map((itemJson) => Item.fromJson(itemJson)).toList();
    } else {
      throw ApiException('アイテムの取得に失敗しました');
    }
  }

  // Item詳細取得リクエスト
  Future<Item> getItemDetail(int id) async {
    final token = await ServiceUtils.getToken();

    final response = await ServiceUtils.getRequest('items/$id', token, null);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Item.fromJson(data['data']);
    } else {
      throw ApiException('アイテムの取得に失敗しました');
    }
  }
}