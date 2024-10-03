import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_sample/src/models/item_model.dart';
import 'package:flutter_sample/src/services/api_exception.dart';
import 'package:flutter_sample/src/services/home_service.dart';

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
  HomeService homeService = HomeService();
  bool _isLoading = false;
  Item _data = Item(id: 0, title: '', description: '', image: '');

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Future.delayed(const Duration(seconds: 1));
      _data = await homeService.getItemDetail(widget.id);

      setState(() {
        _isLoading = false;
      });
    } on ApiException catch (_) {
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    } 
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
              Image.network(_data.image),
              const SizedBox(height: 20),
              Text(
                _data.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Html(
                data: _data.description, 
              ),
            ],
          ),
      ),
    );
  }
}