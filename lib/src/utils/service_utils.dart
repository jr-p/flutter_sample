import 'package:flutter_sample/src/constants/app_const.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceUtils {
  
  static final String baseApiUrl = AppConst.baseApiUrl;

  // リクエストヘッダーを取得
  static Map<String, String> getHeaders(String? token) {
    final header =  token != null
      ? {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
      } : {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
      };
    return header;
  }

  // POSTリクエスト
  static postRequest(String uri, String? token, String? data) async {
    final url = Uri.parse('$baseApiUrl/$uri');
    final headers = getHeaders(token);
    final response = await http.post(
      url,
      headers: headers,
      body: data,
    );
    return response;
  }

  // GETリクエスト
  static getRequest(String uri, String? token, String? param) async {
    final url = Uri.parse(param != null ? '$baseApiUrl/$uri?$param' : '$baseApiUrl/$uri');
    final headers = getHeaders(token);
    final response = await http.get(
      url,
      headers: headers,
    );
    return response;
  }

  // PUTリクエスト
  static putRequest(String uri, String? token, String? data) async {
    final url = Uri.parse('$baseApiUrl/$uri');
    final headers = getHeaders(token);
    final response = await http.put(
      url,
      headers: headers,
      body: data,
    );
    return response;
  }

  // Tokenを取得
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token;
  }

  // Tokenを保存
  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Tokenを削除
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

}