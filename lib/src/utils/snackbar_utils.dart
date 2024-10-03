import 'package:flutter/material.dart';

class SnackbarUtils {
  // 共通のSnackbarを表示するメソッド
  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black, // 背景色も設定できます
        duration: const Duration(seconds: 1), // 表示時間もカスタマイズ可能
      ),
    );
  }
}