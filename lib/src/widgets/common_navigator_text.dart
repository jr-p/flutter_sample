import 'package:flutter/material.dart';

class CommonNavigatorText extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;

  const CommonNavigatorText({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}