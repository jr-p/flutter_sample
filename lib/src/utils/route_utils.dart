import 'package:flutter/material.dart';
import 'package:flutter_sample/src/widgets/auth_wrapper.dart';

class RouteUtils {
  static void navigateToAuthWrapper(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthWrapper()),
      (route) => false, // 以前の画面を削除する
    ); 
  }
}