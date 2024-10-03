import 'package:flutter/material.dart';

// 共通のナビゲーションバー
class CommonNavigationBar extends StatefulWidget {
  const CommonNavigationBar({
    super.key,
    required this.onTap,
    this.currentIndex = 0,
  });

  final ValueChanged<int> onTap;
  final int currentIndex;
  @override
  State<CommonNavigationBar> createState() => _CommonNavigationBarState();
}

class  _CommonNavigationBarState extends State<CommonNavigationBar> {

  // BottomNavigationBar のアイテムリスト
  final List<BottomNavigationBarItem> _items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Setting',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: _items,
      currentIndex: widget.currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.pink,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      onTap: (index) {
        widget.onTap(index);
      },
    );
  }
}