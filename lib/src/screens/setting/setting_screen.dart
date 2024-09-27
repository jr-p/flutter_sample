import 'package:flutter/material.dart';

// 設定画面
class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final List _items = [
    {
      'title': 'アカウント情報変更',
      'route': '/setting/account/edit',
    },
    {
      'title': '電話番号変更',
      'route': '/setting/phone/edit',
    },
    {
      'title': '退会',
      'route': '/setting/withdraw',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Colors.grey[100],
                child: ListTile(
                  title: Center(child: Text(_items[index]['title'], style: const TextStyle(fontWeight: FontWeight.bold))),
                  onTap: () {
                    Navigator.of(context).pushNamed(_items[index]['route']);
                  },
                )
              );
            },
          ),
        ),
      )
    );
  }
}