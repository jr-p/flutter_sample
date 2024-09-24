import 'package:flutter_sample/src/providers/auth_provider.dart';
import 'package:flutter_sample/src/screens/home/home_screen.dart';
import 'package:flutter_sample/src/screens/home/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
import 'package:flutter_sample/src/widgets/common_app_bar.dart';
import 'package:flutter_sample/src/widgets/common_drawer.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // メニューWidgetリスト
  final List<Widget> _screens = [
    const HomeScreen(),
    const SettingScreen(),
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
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Snackbarを表示するためのコールバック
            if (authProvider.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(authProvider.message!, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              );
            }
            // ローディングダイアログを表示・非表示するためのコールバック
            if (authProvider.isLoading) {
              DialogUtils.showLoadingDialog(context);
            } else {
              DialogUtils.hideLoadingDialog(context);
            }
          });
          return _screens[_currentIndex];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
