import 'package:flutter/material.dart';
import 'package:flutter_sample/src/providers/auth_provider.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
import 'package:flutter_sample/src/utils/route_utils.dart';
import 'package:flutter_sample/src/utils/snackbar_utils.dart';
import 'package:flutter_sample/src/widgets/common_app_bar.dart';
import 'package:flutter_sample/src/widgets/common_button.dart';
import 'package:provider/provider.dart';

// 二段階認証画面
class TwoFactorScreen extends StatefulWidget {
  const TwoFactorScreen({ super.key });

  @override
  State<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends State<TwoFactorScreen> {
  static const pinCount = 4; // 認証コードの桁数（4桁）
  final space = '\u200B'; // 空白文字として使うゼロ幅スペース

  List<TextEditingController> controllerList = []; // 各フィールドのテキストコントローラーリスト
  List<FocusNode> focusNodeList = []; // 各フィールドのフォーカスノードリスト

  // 全てのフィールドの入力値を結合して認証コードを取得する
  String get passcode => controllerList.fold<String>(
    '',
    (prev, element) {
      if (element.text.length < 2) {
        return prev;
      }
      return prev + element.text.substring(1, 2); // 各フィールドの2文字目を取得
    }
  );

  @override
  void initState() {
    super.initState();
    // フィールド数に応じてコントローラーとフォーカスノードを初期化
    controllerList =
        List.generate(pinCount, (index) => TextEditingController());
    focusNodeList = List.generate(pinCount, (index) => FocusNode());
  }

  @override
  void dispose() {
    // 各コントローラーとフォーカスノードを破棄
    for (final e in controllerList) {
      e.dispose();
    }
    for (final e in focusNodeList) {
      e.dispose();
    }
    super.dispose();
  }

  // 全ての入力フィールドをクリアする
  void clearAll() {
    if (!mounted) {
      return;
    }
    for (final e in controllerList) {
      e.clear();
    }
  }

  void twoFactorAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    DialogUtils.showLoadingDialog(context);

    await authProvider.twoFactorAuth(passcode);

    if (!mounted) return;

    DialogUtils.hideLoadingDialog(context);

    if (authProvider.message != null) {
      SnackbarUtils.showSnackbar(context, authProvider.message!);
    } else {
      RouteUtils.navigateToAuthWrapper(context);
    }
  }

  void resendTwoFactorAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    clearAll();
    DialogUtils.showLoadingDialog(context);
    
    await authProvider.resendTwoFactorAuth();

    if (!mounted) return;
    
    DialogUtils.hideLoadingDialog(context);

    if (authProvider.message != null) {
      SnackbarUtils.showSnackbar(context, authProvider.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: '二段階認証'), // 共通のAppBar
      body: Padding(
        padding: const EdgeInsets.all(10), // 全体にパディングを設定
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 左寄せに配置
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 均等に配置
              children: [
                const SizedBox(width: 2), // 微調整用のスペース
                // 認証コード用のTextFieldを生成
                ...List.generate(pinCount, _buildTextField),
                const SizedBox(width: 2), // 微調整用のスペース
              ],
            ),
            const SizedBox(height: 40), // 下にスペースを追加
            GestureDetector(
              onTap: resendTwoFactorAuth, // タップ時の処理
              child: const Text(
                '認証コードを再送する',
                style: TextStyle(decoration: TextDecoration.underline), // 下線付きのテキスト
              ),
            ),
            const SizedBox(height: 44), // さらにスペースを追加
            Center(
              child: CommonButton(
                text: '二段階認証をする', // ボタンテキスト
                onPressed: twoFactorAuth,
              ),
            )
          ],
        ),
      ), 
    );
  }

  // 各TextFieldを生成するためのメソッド
  Widget _buildTextField(int index) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(const Size(40, 40)), // サイズを40x40に固定
      child: TextField(
        controller: controllerList[index], // 各フィールドのコントローラー
        keyboardType: TextInputType.number, // 数字入力を指定
        autofocus: index == 0, // 最初のフィールドにフォーカス
        focusNode: focusNodeList[index], // フォーカス管理
        textAlign: TextAlign.center, // 中央揃え
        textAlignVertical: TextAlignVertical.center, // 垂直方向も中央揃え
        onChanged: (str) => _onChanged(str, index), // 入力変更時の処理
        onTap: () => _onTap(index), // タップ時の処理
        style: const TextStyle(fontSize: 32), // フォントサイズを32に設定
        showCursor: false, // カーソルを非表示
      ),
    );
  }

  // TextFieldの入力が変更された時の処理
  void _onChanged(String str, int index) {
    // 1文字入力された時の処理
    if (str.length == 1 && str != space) {
      for (final controller in controllerList) {
        controller.text = space; // 全てのフィールドにスペースをセット
      }
      if (int.tryParse(str) == null) {
        return; // 数字以外なら何もしない
      }
      controllerList[index].value = TextEditingValue(
        text: space + str, // スペースをつけた数字をセット
        selection: const TextSelection.collapsed(offset: 2), // カーソル位置を設定
      );
      if (index == pinCount - 1) {
        focusNodeList[index].unfocus(); // 最後のフィールドならフォーカスを外す
        return;
      }
      focusNodeList[index + 1].requestFocus(); // 次のフィールドにフォーカスを移動
      return;
    }

    // 全てのフィールドに入力された時の処理
    if (str.length == pinCount) {
      str.split('').asMap().forEach((index, value) {
        controllerList[index].value = TextEditingValue(
            text: space + value,
            selection: const TextSelection.collapsed(offset: 2)); // 各フィールドに入力を反映
      });
      focusNodeList[index].unfocus(); // フォーカスを外す
      return;
    }

    // 入力が2文字以上の時の処理
    if (str.length >= 2) {
      if (int.tryParse(str.substring(str.length - 1, str.length)) == null) {
        controllerList[index].value = TextEditingValue(
          text: space, // 数字以外ならスペースに戻す
          selection: const TextSelection.collapsed(offset: 1),
        );
        return;
      }

      if (str.length > 2) {
        final newStr = space + str.substring(str.length - 1, str.length); // 最後の1文字を取得
        controllerList[index].value = TextEditingValue(
          text: newStr,
          selection: const TextSelection.collapsed(offset: 2),
        );
      }

      if (index < pinCount - 1) {
        focusNodeList[index + 1].requestFocus(); // 次のフィールドにフォーカス
      } else if (index == pinCount - 1) {
        focusNodeList[index].unfocus(); // 最後ならフォーカスを外す
      }
      return;
    }

    // 1文字削除された時の処理
    if (str.length == 1 && str == space && index != 0) {
      focusNodeList[index - 1].requestFocus(); // 前のフィールドにフォーカスを戻す
      return;
    }

    // フィールドが空の時の処理
    if (str.isEmpty) {
      controllerList[index].value = TextEditingValue(
          text: space, selection: const TextSelection.collapsed(offset: 1)); // スペースをセット
      if (index != 0) {
        focusNodeList[index - 1].requestFocus(); // 前のフィールドにフォーカス
      }
    }
  }

  // フィールドがタップされた時の処理
  void _onTap(int index) {
    if (controllerList[index].text.isEmpty) {
      controllerList[index].value = TextEditingValue(
        text: space, selection: const TextSelection.collapsed(offset: 1)); // スペースをセット
    }
  }
}