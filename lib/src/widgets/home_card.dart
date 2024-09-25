import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    this.width = double.infinity,
    this.height = 150,
  });
 
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: Colors.transparent, // 半透明の背景
          child: Center(
            child: _buildShimmerEffect(),
          ),
        ),
      ],
    );
  }

  // 煌めきアニメーションを表示するためのウィジェット
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, // 煌めきの色
      highlightColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width, // お好みのサイズ
        height: 100, // お好みのサイズ
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ]
        ),
        child: const Center(
          child: Text(
            'Loading...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      ),
    );
  }
}