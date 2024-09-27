import 'package:flutter/material.dart';

// 共通のボタン
class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.text,
    this.onPressed
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
        ),
        onPressed: onPressed,
        child: Text(text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )
        )
      )
    );
  }
}