import 'package:flutter/material.dart';

// 共通のアプリバー
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    this.title,
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title ?? 'Flutter Sample',  // title が null の場合は 'Flutter Sample' を表示
        style: const TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.pink,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}