import 'package:flutter_sample/src/screens/home/home_screen.dart';
import 'package:flutter_sample/src/screens/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sample/src/widgets/common_app_bar.dart';
import 'package:flutter_sample/src/widgets/common_drawer.dart';
import 'package:flutter_sample/src/widgets/common_navigation_bar.dart';


// 認証後のメイン画面
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

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      endDrawer: const CommonDrawer(),
      body: _screens[currentIndex],
      bottomNavigationBar: CommonNavigationBar(onTap: _onItemTapped, currentIndex: currentIndex),
    );
  }
}
