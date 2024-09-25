import 'package:flutter/material.dart';
import 'package:flutter_sample/src/screens/main_screen.dart';

class CommonNavigationBar extends StatefulWidget {
  const CommonNavigationBar({
    super.key,
    required this.currentIndex,
  });

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
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      onTap: (index) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainScreen(initialIndex: index)),
          (route) => false,
        );
      },
    );
  }
}