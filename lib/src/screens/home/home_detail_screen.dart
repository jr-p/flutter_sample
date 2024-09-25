import 'package:flutter/material.dart';

class HomeDetailScreen extends StatefulWidget {
  const HomeDetailScreen({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<HomeDetailScreen> createState() => _HomeDetailScreenState();
}

class _HomeDetailScreenState extends State<HomeDetailScreen> {
  bool _isLoading = false;
  Map<String, dynamic> _data = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    // APIリクエストのシミュレーション（1秒待機）
    await Future.delayed(const Duration(seconds: 1));

    // データを取得
    _data = {
      'id': widget.id,
      'title': 'Home Detail ${widget.id}',
      'description': 'This is detail of Home Card ${widget.id}',
      'image': 'https://placehold.jp/ff006f/ffffff/150x150.png',
    };

    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(_data['image']),
                  const SizedBox(height: 20),
                  Text(
                    _data['title'],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _data['description'],
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
      ),
    );
  }
}