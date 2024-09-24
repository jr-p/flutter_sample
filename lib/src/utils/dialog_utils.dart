import 'package:flutter/material.dart';

class DialogUtils {
  // ローディングダイアログを表示
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // タップで閉じられないようにする
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(), // ローディングスピナーを表示
        );
      },
    );
  }

  // ローディングダイアログを非表示にする
  static void hideLoadingDialog(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(); // ダイアログを閉じる
    }
  }
}