import 'package:flutter/material.dart';
import 'package:flutter_sample/src/providers/auth_provider.dart';
import 'package:flutter_sample/src/screens/home/home_detail_screen.dart';
import 'package:flutter_sample/src/services/home_service.dart';
import 'package:flutter_sample/src/utils/bottom_sheet_utils.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
import 'package:flutter_sample/src/widgets/home_card.dart';
import 'package:provider/provider.dart';

// ホーム画面
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeService homeService = HomeService(); // サービスクラスをインスタンス化
  bool isLoading = false; // 初回のデータ取得中かどうか
  bool isLoadingMore = false; // 追加データの取得中かどうか
  List<Map<String, dynamic>> data = []; // 取得したデータを保持するリスト
  final ScrollController _scrollController = ScrollController(); // スクロールコントローラー
  int currentPage = 1; // 現在のページ番号（データのページネーションに使用）
  final int itemsPerPage = 4; // 1ページあたりのアイテム数

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener); // スクロールリスナーを追加
    _fetchData(); // 初回のデータ取得を開始
  }

  @override
  void dispose() {
    _scrollController.dispose(); // 使わなくなったスクロールコントローラーを解放
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
      isLoading = true; // データを取得中のフラグを立てる
    });

    // サービスクラスから新しいデータを取得し、リストに追加
    List<Map<String, dynamic>> newData = await homeService.getItems(currentPage);

    setState(() {
      data.addAll(newData); // 新しいデータを既存のリストに追加
      currentPage++; // ページを進める
      isLoading = false; // ローディング状態を解除
    });
  }

  // 追加データを取得するメソッド
  Future<void> _fetchMoreData() async {
    if (isLoadingMore) return; // 既にロード中の場合は処理をスキップ

    setState(() {
      isLoadingMore = true; // 追加データ取得中のフラグを立てる
    });

    Future.delayed(const Duration(seconds: 2)); // データ取得までの待機

    // サービスクラスから追加データを取得し、リストに追加
    List<Map<String, dynamic>> moreData = await homeService.getItems(currentPage);

    setState(() {
      data.addAll(moreData); // 追加データをリストに追加
      currentPage++; // ページを進める
      isLoadingMore = false; // 追加データ取得中のフラグを解除
    });
  }

  @override
  Widget build(BuildContext context) {
    // AuthProviderの状態に応じた処理
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // UI描画後に呼ばれるコールバックを追加
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Snackbarを表示（認証に関するメッセージがある場合）
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
          // ローディングダイアログを表示・非表示（認証中の場合）
          if (authProvider.isLoading) {
            DialogUtils.showLoadingDialog(context);
          } else {
            DialogUtils.hideLoadingDialog(context);
          }
        });
        
        // メインのUI
        return Scaffold(
          // ローディング中かどうかでUIを切り替える
          body: isLoading 
            ? isLoadingMore // 追加データ取得中
              ? const Center(child: CircularProgressIndicator()) // ローディングインジケーター
              : ListView.builder( // ロード中のプレースホルダとしてのカードを表示
                  itemCount: 4, // プレースホルダのカード数
                  itemBuilder: (context, index) => const HomeCard(),
                )
            : ListView.builder( // 通常のリストを表示
              controller: _scrollController, // スクロールコントローラーを指定
              itemCount: data.length + (isLoadingMore ? 1 : 0), // ローディング中のインジケーター用に1アイテム追加
              itemBuilder: (context, index) {
                if (index < data.length) {
                  // 通常のデータをリスト表示
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

  // HomeCardを生成するメソッド
  Widget _buildHomeCard(String image, String title, int id) {
    return Padding(
      padding: const EdgeInsets.all(10), // カードの外側の余白
      child: Container(
        width: double.infinity, // 幅を最大に
        height: 150, // 高さを150に固定
        decoration: BoxDecoration(
          color: Colors.white, // 背景色を白に設定
          borderRadius: BorderRadius.circular(8.0), // 角丸を設定
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // 影の色を半透明の灰色に設定
              spreadRadius: 1, // 影の広がり
              blurRadius: 7, // ぼかし具合
              offset: const Offset(0, 3), // 影の位置
            ),
          ],
        ),
        child: Center(
          // カード内の内容を水平に並べる
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 両端にアイテムを配置
            children: [
              Padding(
                padding: const EdgeInsets.all(8), // 画像周りの余白
                child: Image(image: NetworkImage(image)), // ネットワークから画像を取得して表示
              ),
              Text(title, style: const TextStyle(fontSize: 20)), // タイトルを表示
              IconButton(
                onPressed: () {
                  // カードをタップするとBottomSheetで詳細画面を表示
                  BottomSheetUtils.showBottomSheet(
                    context,
                    HomeDetailScreen(id: id),
                  );
                },
                icon: const Icon(Icons.arrow_forward_ios), // 右向きの矢印アイコン
              )
            ],
          ),
        ),
      ),
    );
  }
}