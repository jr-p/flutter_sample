import 'package:flutter_sample/src/screens/home/home_screen.dart';
import 'package:flutter_sample/src/screens/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sample/src/widgets/common_app_bar.dart';
import 'package:flutter_sample/src/widgets/common_drawer.dart';

class MainScreen extends StatefulWidget {
  final int  initialIndex;
  
  const MainScreen({
    super.key,
    this.initialIndex = 0,
  });


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  // メニューWidgetリスト
  final List<Widget> _screens = [
    const HomeScreen(),
    SettingScreen(),
  ];

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
    return Scaffold(
      appBar: const CommonAppBar(),
      endDrawer: const CommonDrawer(),
      body:  _screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
