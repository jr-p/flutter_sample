import 'package:flutter/material.dart';
import 'package:flutter_sample/src/providers/auth_provider.dart';
import 'package:flutter_sample/src/screens/home/home_detail_screen.dart';
import 'package:flutter_sample/src/utils/bottom_sheet_utils.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
import 'package:flutter_sample/src/widgets/home_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  bool isLoadingMore = false;
  List<Map<String, dynamic>> data = []; // リストに変更
  final ScrollController _scrollController = ScrollController();
  int currentPage = 0;
  final int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    // 初回のデータ取得
    _fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // スクロールリスナー
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // スクロールがリストの一番下に到達したら追加データ取得
      _fetchMoreData();
    }
  }

  // データを取得する（初回ロード時）
  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    // APIリクエストのシミュレーション（2秒待機）
    await Future.delayed(const Duration(seconds: 2));

    // 新しいデータをリストに追加
    List<Map<String, dynamic>> newData = List.generate(itemsPerPage, (index) {
      int itemId = currentPage * itemsPerPage + index + 1;
      return {
        'image': 'https://placehold.jp/ff006f/ffffff/150x150.png',
        'title': 'Home Card $itemId',
        'id': itemId,
      };
    });

    setState(() {
      data.addAll(newData);
      currentPage++;
      isLoading = false;
    });
  }

  // 追加データを取得する
  Future<void> _fetchMoreData() async {
    if (isLoadingMore) return; // すでにロード中なら処理しない

    setState(() {
      isLoadingMore = true;
    });

    // APIリクエストのシミュレーション（2秒待機）
    await Future.delayed(const Duration(seconds: 2));

    // 新しいデータをリストに追加
    List<Map<String, dynamic>> moreData = List.generate(itemsPerPage, (index) {
      int itemId = currentPage * itemsPerPage + index + 1;
      return {
        'image': 'https://placehold.jp/ff006f/ffffff/150x150.png',
        'title': 'Home Card $itemId',
        'id': itemId,
      };
    });

    setState(() {
      data.addAll(moreData);
      currentPage++;
      isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Snackbarを表示するためのコールバック
          if (authProvider.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authProvider.message!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
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
        return Scaffold(
          body: isLoading 
            ? isLoadingMore
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: 7, // Loading時のカード数
                  itemBuilder: (context, index) => const HomeCard(),
                )
            : ListView.builder(
              controller: _scrollController,
              itemCount: data.length + (isLoadingMore ? 1 : 0), // ローディング中のアイテムを追加
              itemBuilder: (context, index) {
                if (index < data.length) {
                  // 通常のリストアイテム
                  return _buildHomeCard(
                      data[index]['image'], data[index]['title'], data[index]['id']);
                } else {
                  // 追加データ取得中のローディングインジケーター
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
        );
      },
    );
  }

  Widget _buildHomeCard(String image, String title, int id) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        height: 150,
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
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Image(image: NetworkImage(image)),
              ),
              Text(title, style: const TextStyle(fontSize: 20)),
              IconButton(
                onPressed: () {
                  BottomSheetUtils.showBottomSheet(
                    context,
                    HomeDetailScreen(id: id),
                  );
                },
                icon: const Icon(Icons.arrow_forward_ios),
              )
            ],
          ),
        ),
      ),
    );
  }
}