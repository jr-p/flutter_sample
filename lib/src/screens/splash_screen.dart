import 'dart:async';
import 'package:flutter_sample/src/widgets/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sample/src/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _counter = 4;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // AnimationControllerの初期化
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _controller.forward();

    _startSplashSequence();
  }

  // スプラッシュ画面のシーケンス処理
  Future<void> _startSplashSequence() async {
    while (_counter > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _counter--;
          _opacity = _counter == 3 ? 0.5 : 1.0;
        });
      }
    }

    // 認証状態をチェックして画面遷移
    await _checkAuthAndNavigate();
  }

  // 認証状態をチェックして画面遷移
  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    // mountedチェックしてからcontextを使ってProviderを呼び出す
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkAuthentication();

    // 再度mountedチェックしてから画面遷移
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 1),
          child: const Text(
            'Flutter Sample',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
