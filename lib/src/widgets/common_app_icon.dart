

import 'package:flutter/material.dart';

class CommonAppIcon extends StatelessWidget {

  const CommonAppIcon({
    super.key,
    required this.size,
  });

  final double size;
  
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.flutter_dash,
      size: size,
      color: Colors.blue,
    );
  }
}