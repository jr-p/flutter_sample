import 'package:flutter/material.dart';

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
          color: Colors.black, 
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}