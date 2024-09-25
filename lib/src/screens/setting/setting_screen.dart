import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final List _items = [
    {
      'title': 'アカウント情報変更',
      'route': '/setting/account/edit',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_items[index]['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.of(context).pushNamed(_items[index]['route']);
              },
            );
          },
        ),
      ),
    );
  }
}