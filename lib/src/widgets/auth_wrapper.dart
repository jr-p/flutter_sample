import 'package:flutter_sample/src/providers/auth_provider.dart';
import 'package:flutter_sample/src/screens/auth/login_screen.dart';
import 'package:flutter_sample/src/screens/auth/two_factor_screen.dart';
import 'package:flutter_sample/src/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 認証状態に応じて画面を切り替えるウィジェット
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isAuthenticated) {
      return authProvider.isTwoAuthenticated
        ? const MainScreen() // ログインしている場合
        : const TwoFactorScreen(); // 二要素認証が必要な場合
    } else {
      return LoginScreen(); // ログイン画面
    }
  }
}
