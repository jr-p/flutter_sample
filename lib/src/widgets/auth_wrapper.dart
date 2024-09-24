import 'package:flutter_sample/src/providers/auth_provider.dart';
import 'package:flutter_sample/src/screens/auth/login_screen.dart';
import 'package:flutter_sample/src/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isAuthenticated) {
      return const MainScreen();
    } else {
      return LoginScreen(); // ログインしていない場合
    }
  }
}
