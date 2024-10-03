import 'package:flutter/material.dart';
import 'package:flutter_sample/src/models/item_model.dart';
import 'package:flutter_sample/src/screens/home/home_detail_screen.dart';
import 'package:flutter_sample/src/services/api_exception.dart';
import 'package:flutter_sample/src/services/home_service.dart';
import 'package:flutter_sample/src/utils/bottom_sheet_utils.dart';
import 'package:flutter_sample/src/widgets/home_card.dart';

// ホーム画面
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeService homeService = HomeService();
  bool _isLoading = false; // 初回のデータ取得中かどうか
  bool _isLoadingMore = false; // 追加データの取得中かどうか
  List<Item> data = [];
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1; // 現在のページ番号（データのページネーションに使用）
  final int itemsPerPage = 4; // 1ページあたりのアイテム数

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchData(); // 初回のデータ取得を開始
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
      // スクロールがリストの一番下に到達したら追加データを取得
      _fetchMoreData();
    }
  }

  // 初回のデータを取得するメソッド
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1)); // データ取得までの待機

    try {
      // サービスクラスから新しいデータを取得し、リストに追加
      List<Item> newData = await homeService.getItems(currentPage);
      if (!mounted) return;
      setState(() {
        data.addAll(newData); // 新しいデータを既存のリストに追加
        currentPage++; // ページを進める
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

  // 追加データを取得するメソッド
  Future<void> _fetchMoreData() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(const Duration(seconds: 1)); // データ取得までの待機

    try {
      // サービスクラスから追加データを取得し、リストに追加
      List<Item> moreData = await homeService.getItems(currentPage);
      setState(() {
        data.addAll(moreData);
        currentPage++;
        _isLoadingMore = false;
      });
    } on ApiException catch (_) {
      setState(() {
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // AuthProviderの状態に応じた処理
    return Scaffold(
      body: _isLoading 
        ? ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) => const HomeCard(),
        ) : ListView.builder(
          controller: _scrollController,
          itemCount: data.length + (_isLoadingMore ? 1 : 0), // ローディング中のインジケーター用に1アイテム追加
          itemBuilder: (context, index) {
            if (index < data.length) {
              // 通常のデータをリスト表示
              return _buildHomeCard(
                data[index].image,
                data[index].title,
                data[index].id
              );
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
  
  }

  // HomeCardを生成するメソッド
  Widget _buildHomeCard(String image, String title, int id) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: double.infinity, // 幅を最大に
        height: 150, // 高さを150に固定
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1, // 影の広がり
              blurRadius: 7, // ぼかし具合
              offset: const Offset(0, 3), // 影の位置
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Image(image: NetworkImage(image)), // ネットワークから画像を取得して表示
              ),
              Text(title, style: const TextStyle(fontSize: 20)),
              IconButton(
                onPressed: () {
                  // カードをタップするとBottomSheetで詳細画面を表示
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